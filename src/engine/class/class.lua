local class = {}
class.__index = class

local idChars = "0123456789abcdef"

local function generateID()
    local id = "Class: 0x"
    for _ = 1, 4 do
        id = id .. idChars:sub(love.math.random(1, #idChars), love.math.random(1, #idChars))
    end
    return id
end

--- Create a new class that extends the current one
---@param name string?
---@return table
function class:extend(name)
    local cls = {}
    for k, v in pairs(self) do
        if k:find("__", 1, true) == 1 then
            cls[k] = v
        end
    end
    cls.__index = cls
    cls.super = self
    cls.__ID = generateID()
    cls._NAME = name or "Class"
    setmetatable(cls, self)
    return cls
end

--- Mixin/Implement methods from other classes
---@param ... table
function class:implement(...)
    for _, cls in pairs({...}) do
        for k, v in pairs(cls) do
            if self[k] == nil and type(v) == "function" then
                self[k] = v
            end
        end
    end
end

--- Check if self is an instance of given class
---@param cls table
---@return boolean
function class:isInstanceOf(cls)
    local m = getmetatable(self)
    while m do
        if m == cls then return true end
        m = m.super
    end
    return false
end

--- To string override to return class ID
---@return string
function class:__tostring()
    return self.__ID
end

--- Instantiate a new object of the class
---@param ... any
---@return any
function class:__call(...)
    local inst = setmetatable({}, self)
    inst.__ID = generateID()
    if inst.new then inst:new(...) end
    return inst
end

return class
