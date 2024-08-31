local path = ...

return {
    LoadAudioData = love.thread.newThread("Modules/Threads/LoadAudioData.lua"),
    LoadImageData = love.thread.newThread("Modules/Threads/LoadImageData.lua")
}