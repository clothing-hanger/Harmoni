extern "C" {
    #include <lua.h>
    #include <lauxlib.h>
}

#include "video.hpp"
#include <string>
#include <memory>

#define MT_NAME "video"

struct VideoWrapper {
    std::unique_ptr<Video> video;
};

static Video* checkVideo(lua_State* L, int i, bool mustBeOpen = true) {
    auto* wrapper = (VideoWrapper*)luaL_checkudata(L, i, MT_NAME);
    if (!wrapper || !wrapper->video)
        luaL_error(L, "attempt to use a deleted video");
    if (mustBeOpen && !wrapper->video->isOpen())
        luaL_error(L, "attempt to use a closed video");
    return wrapper->video.get();
}

static int lua_Video_open(lua_State* L) {
    luaL_checktype(L, 1, LUA_TLIGHTUSERDATA);
    auto* fileContent = static_cast<uint8_t*>(lua_touserdata(L, 1));
    int64_t fileSize = luaL_checkinteger(L, 2);

    auto* udata = (VideoWrapper*)lua_newuserdata(L, sizeof(VideoWrapper));
    new (&udata->video) std::unique_ptr<Video>(new Video(fileContent, fileSize));

    luaL_getmetatable(L, MT_NAME);
    lua_setmetatable(L, -2);

    std::string error;
    if (!udata->video->open(error)) {
        udata->video.reset();
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

static int lua_Video_gc(lua_State* L) {
    auto* wrapper = (VideoWrapper*)luaL_checkudata(L, 1, MT_NAME);
    if (wrapper) wrapper->video.reset();
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

static const luaL_Reg video_methods[] = {
    {"close", lua_Video_close},
    {"read", lua_Video_read},
    {"seek", lua_Video_seek},
    {"getDimensions", lua_Video_getDimensions},
    {"getDuration", lua_Video_getDuration},
    {"tell", lua_Video_tell},
    {NULL, NULL}
};

extern "C" int luaopen_video(lua_State* L) {
    luaL_newmetatable(L, MT_NAME);
    luaL_setfuncs(L, video_methods, 0);

    lua_pushvalue(L, -1);
    lua_setfield(L, -2, "__index");

    lua_pushcfunction(L, lua_Video_gc);
    lua_setfield(L, -2, "__gc");

    lua_newtable(L);
    lua_pushcfunction(L, lua_Video_open);
    lua_setfield(L, -2, "open");
    return 1;
}
