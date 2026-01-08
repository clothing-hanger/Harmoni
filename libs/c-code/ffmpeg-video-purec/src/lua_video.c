#include <lua.h>
#include <lauxlib.h>
#include <stdint.h>
#include <string.h>
#include <stdlib.h>

#include "video.h"

#if defined(_WIN32)
#define LUA_EXPORT __declspec(dllexport)
#else
#define LUA_EXPORT
#endif

#define MT_NAME "video"

typedef struct {
    Video* video;
    int isOpen;
} VideoWrapper;

static VideoWrapper* checkWrapper(lua_State* L, int idx, int mustBeOpen) {
    VideoWrapper* w = (VideoWrapper*)luaL_checkudata(L, idx, MT_NAME);
    if (!w || !w->video)
        luaL_error(L, "attempt to use a deleted video");
    if (mustBeOpen && !w->isOpen)
        luaL_error(L, "attempt to use a closed video");
    return w;
}

static int lua_Video_open(lua_State* L) {
    size_t size = 0;
    const uint8_t* data = (const uint8_t*)luaL_checklstring(L, 1, &size);

    VideoWrapper* w = (VideoWrapper*)lua_newuserdata(L, sizeof(VideoWrapper));
    memset(w, 0, sizeof(VideoWrapper));

    luaL_getmetatable(L, MT_NAME);
    lua_setmetatable(L, -2);

    char error[256];
    w->video = video_create((uint8_t*)data, (int64_t)size);
    if (!w->video) {
        lua_pop(L, 1);
        lua_pushnil(L);
        lua_pushstring(L, "failed to allocate video");
        return 2;
    }

    if (!video_open(w->video, error, sizeof(error))) {
        video_destroy(w->video);
        w->video = NULL;
        lua_pop(L, 1);
        lua_pushnil(L);
        lua_pushstring(L, error);
        return 2;
    }

    w->isOpen = 1;
    return 1;
}

static int lua_Video_close(lua_State* L) {
    VideoWrapper* w = checkWrapper(L, 1, 0);
    if (w->video && w->isOpen) {
        video_close(w->video);
        w->isOpen = 0;
    }
    return 0;
}

static int lua_Video_read(lua_State* L) {
    VideoWrapper* w = checkWrapper(L, 1, 1);

    void* dst = NULL;
    if (lua_gettop(L) >= 2 && lua_type(L, 2) == LUA_TLIGHTUSERDATA)
        dst = lua_touserdata(L, 2);

    double timestamp = 0.0;
    if (!video_read_frame(w->video, dst, &timestamp))
        return 0;

    lua_pushnumber(L, timestamp);
    return 1;
}

static int lua_Video_seek(lua_State* L) {
    VideoWrapper* w = checkWrapper(L, 1, 1);
    double time = luaL_checknumber(L, 2);

    char error[256];
    if (!video_seek(w->video, time, error, sizeof(error))) {
        lua_pushnil(L);
        lua_pushstring(L, error);
        return 2;
    }

    lua_pushboolean(L, 1);
    return 1;
}

static int lua_Video_getDimensions(lua_State* L) {
    VideoWrapper* w = checkWrapper(L, 1, 1);
    lua_pushinteger(L, video_get_width(w->video));
    lua_pushinteger(L, video_get_height(w->video));
    return 2;
}

static int lua_Video_getDuration(lua_State* L) {
    VideoWrapper* w = checkWrapper(L, 1, 1);
    lua_pushnumber(L, video_get_duration(w->video));
    return 1;
}

static int lua_Video_tell(lua_State* L) {
    VideoWrapper* w = checkWrapper(L, 1, 1);
    lua_pushnumber(L, video_tell(w->video));
    return 1;
}

static int lua_Video_getFPS(lua_State* L) {
    VideoWrapper* w = checkWrapper(L, 1, 1);
    lua_pushnumber(L, video_get_fps(w->video));
    return 1;
}

static int lua_Video_gc(lua_State* L) {
    VideoWrapper* w = (VideoWrapper*)luaL_checkudata(L, 1, MT_NAME);
    if (w && w->video) {
        video_destroy(w->video);
        w->video = NULL;
        w->isOpen = 0;
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
