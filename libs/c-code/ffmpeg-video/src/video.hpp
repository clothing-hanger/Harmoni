#pragma once

extern "C" {
    #include <lua.h>
    #include <lauxlib.h>
    #include <libavcodec/avcodec.h>
    #include <libavformat/avformat.h>
    #include <libavutil/avutil.h>
    #include <libavutil/imgutils.h>
    #include <libswscale/swscale.h>
}

#include <cstdint>
#include <string>
#include <memory>

struct AVDeleter {
    void operator()(AVFormatContext* ctx) const { if (ctx) avformat_close_input(&ctx); }
    void operator()(AVCodecContext* ctx) const { avcodec_free_context(&ctx); }
    void operator()(AVIOContext* ctx) const { if (ctx) avio_context_free(&ctx); }
    void operator()(AVFrame* f) const { av_frame_free(&f); }
    void operator()(SwsContext* sws) const { sws_freeContext(sws); }
};

class Video {
public:
    Video(uint8_t* fileContent, int64_t fileSize);
    Video::~Video() = default;

    bool open(std::string& error);
    void close();

    bool readFrame(void* dst, double& timestamp);
    bool seek(double time, std::string& error);

    int getWidth() const;
    int getHeight() const;
    double getDuration() const;
    double tell() const;

    bool isOpen() const { return isOpened; }

private:
    std::unique_ptr<AVFormatContext, AVDeleter> formatContext{nullptr};
    std::unique_ptr<AVIOContext, AVDeleter> ioContext{nullptr};
    const AVCodec* codec = nullptr;
    std::unique_ptr<AVCodecContext, AVDeleter> codecContext{nullptr};
    int streamIndex = -1;
    AVStream* stream = nullptr;
    std::unique_ptr<AVFrame, AVDeleter> frame{nullptr};
    std::unique_ptr<AVFrame, AVDeleter> frameRGB{nullptr};
    std::unique_ptr<SwsContext, AVDeleter> swsContext{nullptr};

    uint8_t* image = nullptr;
    int imageSize = 0;
    uint8_t* fileBuffer = nullptr;
    uint8_t* fileContent = nullptr;
    int64_t fileSize = 0;
    int64_t fileOffset = 0;

    bool isOpened = false;

    static int fileRead(void* ptr, uint8_t* buf, int len);
    static int64_t fileSeek(void* ptr, int64_t pos, int whence);
};
