require "love.filesystem"
require "love.image"

local outputChannel = love.thread.getChannel("ThreadChannels.LoadGraphic.Output")

local allFiles = {...}
local allAssets = {}

for _, file in ipairs(allFiles) do
    local filepath = file

    local asset = love.image.newImageData(file)

    table.insert(allAssets, {
        filepath, asset
    })
end

outputChannel:push(allAssets)