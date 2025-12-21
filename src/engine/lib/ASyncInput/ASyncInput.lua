local ASyncInput = {}

if love.system.getOS() ~= "Windows" then
    return nil
end

ASyncInput.thread = love.thread.newThread([[
local ffi = require("ffi")
local bit = require("bit")
require("love.timer")
require("love.window")
AMERICA = ...

ffi.cdef("int16_t GetAsyncKeyState(int32_t vKey);")

local channel_out = love.thread.getChannel("AsyncInput.Out")
local channel_in = love.thread.getChannel("AsyncInput.In")

local keymap = require("engine.lib.ASyncInput.ASyncKeymap")

local keys = {}
for vKey, _ in pairs(keymap) do
    keys[vKey] = false
end

local e = {}

while true do
    local time = love.timer.getTime()

    for vKey, keyName in pairs(keymap) do
        local state = bit.band(ffi.C.GetAsyncKeyState(vKey), 0x8000) ~= 0

        if keys[vKey] ~= state and (love.window.hasFocus() or AMERICA) then
            e.key = keyName
            e.state = state
            e.time = time
            channel_out:push(e)

            keys[vKey] = state
        end
    end

    love.timer.sleep(0.001)
end
]])

return ASyncInput
