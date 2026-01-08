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

static int lua_Video_open(lua_State *L) {
    Video *v;
    uint8_t *data;
    int64_t size;
    char error[256];

    luaL_checktype(L, 1, LUA_TLIGHTUSERDATA);
    data = (uint8_t *)lua_touserdata(L, 1);
    size = (int64_t)luaL_checkinteger(L, 2);

    v = video_create(data, size);
    if (!v) {
        lua_pushnil(L);
        lua_pushstring(L, "Failed to create video");
        return 2;
    }

    if (!video_open(v, error, sizeof(error))) {
        video_destroy(v);
        lua_pushnil(L);
        lua_pushstring(L, error);
        return 2;
    }

    Video **ud = (Video **)lua_newuserdata(L, sizeof(Video *));
    *ud = v;

    luaL_getmetatable(L, MT_NAME);
    lua_setmetatable(L, -2);

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
