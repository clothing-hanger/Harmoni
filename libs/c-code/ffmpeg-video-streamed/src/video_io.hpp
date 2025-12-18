#pragma once
#include <cstdint>
#include <cstdio>
#include <algorithm>
#include <cstring>
#include <string>

#ifdef _WIN32
#define NOMINMAX
#define WIN32_LEAN_AND_MEAN
#include <windows.h>

static std::wstring utf8ToWide(const std::string& s) {
    int len = MultiByteToWideChar(CP_UTF8, 0, s.c_str(), -1, nullptr, 0);
    std::wstring w(len, L'\0');
    MultiByteToWideChar(CP_UTF8, 0, s.c_str(), -1, w.data(), len);
    return w;
}
#endif

struct VideoIO {
    virtual ~VideoIO() = default;
    virtual int read(uint8_t* buf, int len) = 0;
    virtual int64_t seek(int64_t pos, int whence) = 0;
    virtual int64_t size() const = 0;
};

struct MemoryIO : VideoIO {
    uint8_t* data;
    int64_t size_;
    int64_t offset = 0;

    MemoryIO(uint8_t* d, int64_t s)
        : data(d), size_(s) {}

    int read(uint8_t* dst, int len) override {
        int64_t remaining = size_ - offset;
        if (remaining <= 0) return 0;

        int toRead = (int)std::min<int64_t>(len, remaining);
        std::memcpy(dst, data + offset, toRead);
        offset += toRead;
        return toRead;
    }

    int64_t seek(int64_t pos, int whence) override {
        int64_t newPos = offset;

        switch (whence) {
            case SEEK_SET: newPos = pos; break;
            case SEEK_CUR: newPos += pos; break;
            case SEEK_END: newPos = size_ + pos; break;
            case AVSEEK_SIZE: return size_;
        }

        if (newPos < 0 || newPos > size_) return -1;
        offset = newPos;
        return offset;
    }

    int64_t size() const override {
        return size_;
    }
};

struct FileIO : VideoIO {
    FILE* f = nullptr;
    int64_t size_ = 0;

    explicit FileIO(const char* path) {
        #ifdef _WIN32  // those who tickle their pickle to agnes tachyon
            std::wstring wpath = utf8ToWide(path);
            f = _wfopen(wpath.c_str(), L"rb");
        #else
            f = fopen(path, "rb");
        #endif
        if (!f) return;

        #ifdef _WIN32  // i could just put bullshit in the cpp files cuz ch is never gonna look here
            if (_fseeki64(f, 0, SEEK_END) != 0) { fclose(f); f = nullptr; return; }
            size_ = _ftelli64(f);
            _fseeki64(f, 0, SEEK_SET);
        #else
            if (fseeko(f, 0, SEEK_END) != 0) { fclose(f); f = nullptr; return; }
            size_ = ftello(f);
            fseeko(f, 0, SEEK_SET);
        #endif
    }

    ~FileIO() override {
        if (f) std::fclose(f);
    }

    int read(uint8_t* buf, int len) override {
        if (!f) return AVERROR(EIO);
        size_t r = std::fread(buf, 1, len, f);
        if (ferror(f)) return AVERROR(EIO);
        return (int)r;
    }

    int64_t seek(int64_t pos, int whence) override {
        if (!f) return -1;

        if (whence == AVSEEK_SIZE) return size_;

        whence &= ~AVSEEK_FORCE;

        #ifdef _WIN32
            if (_fseeki64(f, pos, whence) != 0) return -1;
            return _ftelli64(f);
        #else
            if (fseeko(f, pos, whence) != 0) return -1;
            return ftello(f);
        #endif
    }

    int64_t size() const override {
        return size_;
    }
};

