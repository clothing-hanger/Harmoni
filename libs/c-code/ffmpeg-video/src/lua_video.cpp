extern "C" {
#include <lua.h>
#include <lauxlib.h>
}

#include "video.hpp"
#include <string>
#include <atomic>
#include <new>

#if defined(_WIN32)
#define LUA_EXPORT extern "C" __declspec(dllexport)
#else
#define LUA_EXPORT extern "C"
#endif

#define MT_NAME "video"
struct VideoWrapper {
    std::atomic<int> refCount;
    Video* video;

    VideoWrapper(uint8_t* data, int64_t size)
        : refCount(1), video(new Video(data, size)) {}

    ~VideoWrapper() {
        delete video;
    }
};

static VideoWrapper* checkWrapper(lua_State* L, int idx) {
    auto* w = (VideoWrapper*)luaL_checkudata(L, idx, MT_NAME);
    if (!w || !w->video)
        luaL_error(L, "attempt to use a deleted video");
    return w;
}

static Video* checkVideo(lua_State* L, int idx, bool mustBeOpen = true) {
    auto* w = checkWrapper(L, idx);
    if (mustBeOpen && !w->video->isOpen())
        luaL_error(L, "attempt to use a closed video");
    return w->video;
}

static int lua_Video_open(lua_State* L) {
    size_t size = 0;
    const uint8_t* data = (const uint8_t*)luaL_checklstring(L, 1, &size);

    void* mem = lua_newuserdata(L, sizeof(VideoWrapper));
    auto* wrapper = new (mem) VideoWrapper((uint8_t*)data, (int64_t)size);

    luaL_getmetatable(L, MT_NAME);
    lua_setmetatable(L, -2);

    std::string error;
    if (!wrapper->video->open(error)) {
        wrapper->~VideoWrapper();
        lua_pop(L, 1);
        lua_pushnil(L);
        lua_pushstring(L, error.c_str());
        return 2;
    }

    return 1;
}

static int lua_Video_close(lua_State* L) {
    auto* video = checkVideo(L, 1);
    video->close();
    return 0;
}

static int lua_Video_read(lua_State* L) {
    auto* video = checkVideo(L, 1);

    void* dst = nullptr;
    if (lua_gettop(L) >= 2 && lua_type(L, 2) == LUA_TLIGHTUSERDATA)
        dst = lua_touserdata(L, 2);

    double timestamp;
    if (!video->readFrame(dst, timestamp))
        return 0;

    lua_pushnumber(L, timestamp);
    return 1;
}

static int lua_Video_seek(lua_State* L) {
    auto* video = checkVideo(L, 1);
    double time = luaL_checknumber(L, 2);

    std::string error;
    if (!video->seek(time, error)) {
        lua_pushnil(L);
        lua_pushstring(L, error.c_str());
        return 2;
    }

    lua_pushboolean(L, 1);
    return 1;
}

static int lua_Video_getDimensions(lua_State* L) {
    auto* video = checkVideo(L, 1);
    lua_pushinteger(L, video->getWidth());
    lua_pushinteger(L, video->getHeight());
    return 2;
}

static int lua_Video_getDuration(lua_State* L) {
    auto* video = checkVideo(L, 1);
    lua_pushnumber(L, video->getDuration());
    return 1;
}

static int lua_Video_tell(lua_State* L) {
    auto* video = checkVideo(L, 1);
    lua_pushnumber(L, video->tell());
    return 1;
}

static int lua_Video_getFPS(lua_State* L) {
    auto* video = checkVideo(L, 1);
    lua_pushnumber(L, video->getFPS());
    return 1;
}

static int lua_Video_retain(lua_State* L) {
    auto* w = checkWrapper(L, 1);
    w->refCount.fetch_add(1, std::memory_order_relaxed);
    lua_pushvalue(L, 1);
    return 1;
}

static int lua_Video_release(lua_State* L) {
    auto* w = checkWrapper(L, 1);
    if (w->refCount.fetch_sub(1, std::memory_order_acq_rel) == 1) {
        w->~VideoWrapper();
    }
    return 0;
}

static int lua_Video_gc(lua_State* L) {
    auto* w = (VideoWrapper*)luaL_checkudata(L, 1, MT_NAME);
    if (w && w->refCount.fetch_sub(1, std::memory_order_acq_rel) == 1) {
        w->~VideoWrapper();
    }
    return 0;
}

static const luaL_Reg video_methods[] = {
    {"close", lua_Video_close},
    {"read", lua_Video_read},
    {"seek", lua_Video_seek},
    {"getDimensions", lua_Video_getDimensions},
    {"getDuration", lua_Video_getDuration},
    {"tell", lua_Video_tell},
    {"getFPS", lua_Video_getFPS},
    {"retain", lua_Video_retain},
    {"release", lua_Video_release},
    {"__gc", lua_Video_gc},
    {NULL, NULL}
};

LUA_EXPORT int luaopen_video(lua_State* L) {
#if LUA_VERSION_NUM >= 502
    luaL_checkversion(L);
#endif

    luaL_newmetatable(L, MT_NAME);
    luaL_setfuncs(L, video_methods, 0);

    lua_pushvalue(L, -1);
    lua_setfield(L, -2, "__index");

    lua_newtable(L);
    lua_pushcfunction(L, lua_Video_open);
    lua_setfield(L, -2, "open");

    return 1;
}
