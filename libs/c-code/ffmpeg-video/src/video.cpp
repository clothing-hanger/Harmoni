#include "video.hpp"
#include <cstring>
#include <cstdlib>
#include <stdexcept>

#define FILE_BUFFER_SIZE 1048576

Video::Video(uint8_t* content, int64_t size)
    : fileContent(content), fileSize(size), fileOffset(0) {}

int Video::fileRead(void* ptr, uint8_t* buf, int len) {
    auto* video = reinterpret_cast<Video*>(ptr);
    int64_t n = std::min<int64_t>(len, video->fileSize - video->fileOffset);
    if (n <= 0) return AVERROR_EOF;
    std::memcpy(buf, video->fileContent + video->fileOffset, n);
    video->fileOffset += n;
    return static_cast<int>(n);
}

int64_t Video::fileSeek(void* ptr, int64_t pos, int whence) {
    auto* video = reinterpret_cast<Video*>(ptr);
    if (whence == AVSEEK_SIZE)
        return video->fileSize;

    video->fileOffset = pos;
    return pos;
}

bool Video::open(std::string& error) { // straight up rubbin' my belly
    isOpened = true;

    fileBuffer = static_cast<uint8_t*>(av_malloc(FILE_BUFFER_SIZE));
    if (!fileBuffer) { error = "Can't allocate file buffer"; return false; }

    ioContext.reset(
        avio_alloc_context(fileBuffer, FILE_BUFFER_SIZE, 0, this, fileRead, nullptr, fileSeek)
    );
    if (!ioContext) { error = "Can't allocate AVIOContext"; return false; }

    formatContext.reset(nullptr);

    AVFormatContext* rawCtx = avformat_alloc_context();
    if (!rawCtx) { error = "Can't allocate context"; return false; }

    rawCtx->pb = ioContext.get();
    rawCtx->flags |= AVFMT_FLAG_CUSTOM_IO;

    if (avformat_open_input(&rawCtx, nullptr, nullptr, nullptr) != 0) {
        error = "Can't open input";
        return false;
    }

    formatContext.reset(rawCtx);

    if (avformat_find_stream_info(formatContext.get(), nullptr) != 0) {
        error = "Can't find stream info"; return false;
    }

    streamIndex = av_find_best_stream(formatContext.get(), AVMEDIA_TYPE_VIDEO, -1, -1, &codec, 0);
    if (streamIndex < 0) { error = "No video stream found"; return false; }

    stream = formatContext->streams[streamIndex];

    codecContext.reset(avcodec_alloc_context3(codec));
    if (!codecContext) { error = "Can't allocate AVCodecContext"; return false; }

    if (avcodec_parameters_to_context(codecContext.get(), stream->codecpar) < 0) {
        error = "Can't fill codec context"; return false;
    }

    if (avcodec_open2(codecContext.get(), codec, nullptr) != 0) {
        error = "Can't open codec"; return false;
    }

    frame.reset(av_frame_alloc());
    frameRGB.reset(av_frame_alloc());
    if (!frame || !frameRGB) { error = "Can't allocate frames"; return false; }

    imageSize = av_image_get_buffer_size(AV_PIX_FMT_RGBA, codecContext->width, codecContext->height, 1);
    image = static_cast<uint8_t*>(malloc(imageSize));
    if (!image) { error = "Can't allocate image buffer"; return false; }

    if (av_image_fill_arrays(
        frameRGB->data, frameRGB->linesize, image, AV_PIX_FMT_RGBA,
        codecContext->width, codecContext->height, 1) < 0
    ) {
        error = "Can't fill image arrays"; return false;
    }

    swsContext.reset(sws_getContext(
        codecContext->width, codecContext->height, codecContext->pix_fmt,
        codecContext->width, codecContext->height, AV_PIX_FMT_RGBA,
        SWS_FAST_BILINEAR, nullptr, nullptr, nullptr
    ));
    if (!swsContext) { error = "Can't allocate SwsContext"; return false; }

    return true;
}

void Video::close() {
    if (!isOpened) return;
    isOpened = false;

    if (image) { av_free(image); image = nullptr; }

    frame.reset();
    frameRGB.reset();
    codecContext.reset();
    formatContext.reset();
    ioContext.reset();
}

bool Video::readFrame(void* dst, double& timestamp) { // this could probably be better but i lowkey dgaf
    AVPacket pkt;
    av_new_packet(&pkt, 0);

    while (av_read_frame(formatContext.get(), &pkt) >= 0) {
        if (pkt.stream_index != streamIndex) {
            av_packet_unref(&pkt);
            continue;
        }

        if (avcodec_send_packet(codecContext.get(), &pkt) < 0) {
            av_packet_unref(&pkt);
            continue;
        }

        while (avcodec_receive_frame(codecContext.get(), frame.get()) == 0) {
            sws_scale(
                swsContext.get(),
                frame->data, frame->linesize,
                0, codecContext->height,
                frameRGB->data, frameRGB->linesize
            );

            if (dst) std::memcpy(dst, image, imageSize);

            int64_t pts = frame->best_effort_timestamp;
            AVRational base = stream->time_base;
            timestamp = (double)pts * base.num / base.den;

            av_packet_unref(&pkt);
            return true;
        }

        av_packet_unref(&pkt);
    }

    return false;
}

bool Video::seek(double time, std::string& error) {
    if (!stream) { error = "No video stream"; return false; }

    AVRational tb = stream->time_base;
    int64_t target_pts = av_rescale_q((int64_t)(time * AV_TIME_BASE), AV_TIME_BASE_Q, tb);

    if (stream->start_time != AV_NOPTS_VALUE)
        target_pts += stream->start_time;

    int flags = AVSEEK_FLAG_ANY;

    if (av_seek_frame(formatContext.get(), streamIndex, target_pts, flags) < 0) {
        error = "Seek failed";
        return false;
    }

    avcodec_flush_buffers(codecContext.get());
    return true;
}

int Video::getWidth() const { return codecContext ? codecContext->width : 0; }
int Video::getHeight() const { return codecContext ? codecContext->height : 0; }

double Video::getDuration() const {
    if (!stream) return 0.0;
    AVRational base = stream->time_base;
    return (double)stream->duration * base.num / base.den;
}

double Video::tell() const {
    if (!frame || !stream) return 0.0;
    int64_t effort = frame->best_effort_timestamp;
    AVRational base = stream->time_base;
    return (effort < 0) ? 0.0 : (double)effort * base.num / base.den;
}
