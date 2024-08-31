require "love.filesystem"
require "love.sound"

local outputChannel = love.thread.getChannel("ThreadChannels.LoadAudioData.Output")

local filename = ...

outputChannel:push(love.sound.newSoundData(filename))