#include "video.h"

#include <stdlib.h>
#include <string.h>
#include <math.h>

#include <libavcodec/avcodec.h>
#include <libavformat/avformat.h>
#include <libavutil/avutil.h>
#include <libavutil/imgutils.h>
#include <libswscale/swscale.h>

#define FILE_BUFFER_SIZE 1048576

struct Video {
    AVFormatContext* formatContext;
    AVIOContext* ioContext;
    AVCodecContext* codecContext;
    const AVCodec* codec;

    AVStream* stream;
    int streamIndex;

    AVFrame* frame;
    AVFrame* frameRGB;
    struct SwsContext* swsContext;

    AVPacket packet;

    uint8_t* image;
    int imageSize;

    uint8_t* ownedData;
    uint8_t* fileBuffer;
    int64_t fileSize;
    int64_t fileOffset;

    int isOpened;
};

static int fileRead(void* ptr, uint8_t* buf, int len) {
    Video* v = (Video*)ptr;
    int64_t remain = v->fileSize - v->fileOffset;
    if (remain <= 0) return AVERROR_EOF;

    if (len > remain) len = (int)remain;
    memcpy(buf, v->ownedData + v->fileOffset, len);
    v->fileOffset += len;
    return len;
}

static int64_t fileSeek(void* ptr, int64_t pos, int whence) {
    Video* v = ptr;

    if (whence == AVSEEK_SIZE)
        return v->fileSize;

    int64_t newPos;
    switch (whence) {
        case SEEK_SET: newPos = pos; break;
        case SEEK_CUR: newPos = v->fileOffset + pos; break;
        case SEEK_END: newPos = v->fileSize + pos; break;
        default: return -1;
    }

    if (newPos < 0 || newPos > v->fileSize)
        return -1;

    v->fileOffset = newPos;
    return newPos;
}

Video* video_create(uint8_t* data, int64_t size) {
    Video* v = (Video*)calloc(1, sizeof(Video));
    if (!v) return NULL;

    v->ownedData = (uint8_t*)malloc(size);
    if (!v->ownedData) {
        free(v);
        return NULL;
    }

    memcpy(v->ownedData, data, size);
    v->fileSize = size;
    v->fileOffset = 0;
    return v;
}

void video_destroy(Video* v) {
    if (!v) return;
    video_close(v);
    free(v->ownedData);
    free(v);
}

int video_open(Video* v, char* error, int errorSize) {
    v->isOpened = 1;

    v->fileBuffer = av_malloc(FILE_BUFFER_SIZE);
    if (!v->fileBuffer) {
        snprintf(error, errorSize, "Can't allocate file buffer");
        return 0;
    }

    v->ioContext = avio_alloc_context(
        v->fileBuffer, FILE_BUFFER_SIZE, 0, v, fileRead, NULL, fileSeek
    );
    if (!v->ioContext) {
        snprintf(error, errorSize, "Can't allocate AVIOContext");
        return 0;
    }

    v->formatContext = avformat_alloc_context();
    if (!v->formatContext) {
        snprintf(error, errorSize, "Can't allocate AVFormatContext");
        return 0;
    }

    v->formatContext->pb = v->ioContext;
    v->formatContext->flags |= AVFMT_FLAG_CUSTOM_IO;

    if (avformat_open_input(&v->formatContext, NULL, NULL, NULL) < 0) {
        snprintf(error, errorSize, "Can't open input");
        return 0;
    }

    if (avformat_find_stream_info(v->formatContext, NULL) < 0) {
        snprintf(error, errorSize, "Can't find stream info");
        return 0;
    }

    v->streamIndex = av_find_best_stream(
        v->formatContext, AVMEDIA_TYPE_VIDEO, -1, -1, &v->codec, 0
    );
    if (v->streamIndex < 0) {
        snprintf(error, errorSize, "No video stream found");
        return 0;
    }

    v->stream = v->formatContext->streams[v->streamIndex];

    v->codecContext = avcodec_alloc_context3(v->codec);
    avcodec_parameters_to_context(v->codecContext, v->stream->codecpar);

    if (avcodec_open2(v->codecContext, v->codec, NULL) < 0) {
        snprintf(error, errorSize, "Can't open codec");
        return 0;
    }

    v->frame = av_frame_alloc();
    v->frameRGB = av_frame_alloc();

    v->imageSize = av_image_get_buffer_size(
        AV_PIX_FMT_RGBA,
        v->codecContext->width,
        v->codecContext->height,
        1
    );

    v->image = av_malloc(v->imageSize);

    av_image_fill_arrays(
        v->frameRGB->data,
        v->frameRGB->linesize,
        v->image,
        AV_PIX_FMT_RGBA,
        v->codecContext->width,
        v->codecContext->height,
        1
    );

    if (v->codecContext->pix_fmt != AV_PIX_FMT_RGBA) {
        v->swsContext = sws_getContext(
            v->codecContext->width,
            v->codecContext->height,
            v->codecContext->pix_fmt,
            v->codecContext->width,
            v->codecContext->height,
            AV_PIX_FMT_RGBA,
            SWS_FAST_BILINEAR,
            NULL, NULL, NULL
        );
    }

    av_init_packet(&v->packet);
    return 1;
}

void video_close(Video* v) {
    if (!v || !v->isOpened) return;
    v->isOpened = 0;

    if (v->image) av_free(v->image);
    if (v->frame) av_frame_free(&v->frame);
    if (v->frameRGB) av_frame_free(&v->frameRGB);
    if (v->swsContext) sws_freeContext(v->swsContext);
    if (v->codecContext) avcodec_free_context(&v->codecContext);
    if (v->formatContext) avformat_close_input(&v->formatContext);
    if (v->ioContext) avio_context_free(&v->ioContext);
}

int video_read_frame(Video* v, void* dst, double* timestamp) {
    while (av_read_frame(v->formatContext, &v->packet) >= 0) {
        if (v->packet.stream_index != v->streamIndex) {
            av_packet_unref(&v->packet);
            continue;
        }

        avcodec_send_packet(v->codecContext, &v->packet);
        av_packet_unref(&v->packet);

        if (avcodec_receive_frame(v->codecContext, v->frame) == 0) {
            if (v->swsContext) {
                sws_scale(
                    v->swsContext,
                    (const uint8_t* const*)v->frame->data,
                    v->frame->linesize,
                    0,
                    v->codecContext->height,
                    v->frameRGB->data,
                    v->frameRGB->linesize
                );
            } else {
                av_image_copy(
                    v->frameRGB->data,
                    v->frameRGB->linesize,
                    (const uint8_t* const*)v->frame->data,
                    v->frame->linesize,
                    AV_PIX_FMT_RGBA,
                    v->codecContext->width,
                    v->codecContext->height
                );
            }

            if (dst)
                memcpy(dst, v->image, v->imageSize);

            AVRational tb = v->stream->time_base;
            *timestamp = v->frame->best_effort_timestamp * (double)tb.num / tb.den;
            return 1;
        }
    }
    return 0;
}

int video_seek(Video* v, double time, char* error, int errorSize) {
    AVRational tb = v->stream->time_base;
    int64_t ts = (int64_t)(time * tb.den / tb.num);
    if (av_seek_frame(v->formatContext, v->streamIndex, ts, AVSEEK_FLAG_BACKWARD) < 0) {
        snprintf(error, errorSize, "Seek failed");
        return 0;
    }
    avcodec_flush_buffers(v->codecContext);
    return 1;
}

int video_get_width(Video* v) { return v->codecContext->width; }
int video_get_height(Video* v) { return v->codecContext->height; }

double video_get_duration(Video* v) {
    AVRational tb = v->stream->time_base;
    return v->stream->duration * (double)tb.num / tb.den;
}

double video_tell(Video* v) {
    AVRational tb = v->stream->time_base;
    return v->frame->best_effort_timestamp * (double)tb.num / tb.den;
}

double video_get_fps(Video* v) {
    AVRational r = v->stream->avg_frame_rate;
    return r.den ? (double)r.num / r.den : 0.0;
}
