local ffi = require("ffi")
local SDL2
local module = {}
local okay = true

local success, err = pcall(function()
    SDL2 = ffi.load("SDL2")
end)

if not success then
    print("Failed to load SDL2:", err)
    okay = false
end

if not okay then return end

ffi.cdef[[
typedef struct SDL_Locale {
    const char* language;
    const char* country;
} SDL_Locale;

SDL_Locale* SDL_GetPreferredLocales(void);
]]

function module.getPreferredLocales()
    local locales = SDL2.SDL_GetPreferredLocales()
    local result = {}

    if locales == nil then
        return result
    end

    local i = 0
    while locales[i].language ~= nil do
        table.insert(result, {
            language = ffi.string(locales[i].language),
            country = locales[i].country ~= nil and ffi.string(locales[i].country) or ""
        })
        i = i + 1
    end

    return result
end

return module
