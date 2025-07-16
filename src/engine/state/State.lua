---@alias State table
---@class state
local state = {}
state.__index = state
state.__storage = {}

local current, last, substate = nil, nil, nil
state.inSubstate = false

-- Internal switch logic
local function switch(newstate, ...)
    if current and current.exit then current:exit() end
    last = current
    current = newstate
    if current.enter then current:enter(last, ...) end
    collectgarbage("collect")
    return current
end

-- Internal pop logic
local function pop(newstate, ...)
    if current and current.exit then current:exit() end
    last = current
    current = newstate
    if current.reload then current:reload(last, ...) end
    return current
end

function state.switch(newstate, ...)
    assert(type(newstate) == "table", "Called state.switch with invalid or no state")
    return switch(newstate, ...)
end

function state.push(newstate, ...)
    assert(type(newstate) == "table", "Called state.push with invalid or no state")
    table.insert(state.__storage, current)
    return switch(newstate, ...)
end

function state.pop()
    assert(#state.__storage > 0, "Called state.pop with no states in storage")
    return pop(table.remove(state.__storage))
end

function state.popAll()
    assert(#state.__storage > 0, "Called state.popAll with no states in storage")
    return pop(table.remove(state.__storage, 1))
end

function state.current() return current end
function state.last() return last end
function state.currentSubstate() return substate end

function state.returnToLast()
    assert(last, "Called state.returnToLast with no last state")
    return switch(last)
end

function state.substate(newstate, ...)
    assert(type(newstate) == "table", "Called state.substate with invalid or no state")
    substate = newstate
    state.inSubstate = true
    if substate.enter then substate:enter(...) end
    return substate
end

function state.killSubstate(...)
    if substate and substate.exit then substate:exit() end
    substate = nil
    state.inSubstate = false
    if current and current.substateReturn then current:substateReturn(...) end
end

-- Generate a new named state
local function new(name)
    name = name or ("State." .. string.format("%x", love.math.random(0, 0xFFFFFFFF)))
    return setmetatable({
        __name = name
    }, {
        __tostring = function() return name end,
        __call = function(self, ...) return state.switch(self, ...) end
    })
end

local unpack = table.unpack or unpack

-- Forward calls to current and substate (e.g. update, draw)
setmetatable(state, {
    __index = function(_, func)
        return function(...)
            local args = {...}
            if current and current[func] then current[func](current, unpack(args)) end
            if substate and substate[func] then substate[func](substate, unpack(args)) end
        end
    end,
    __call = function(_, name) return new(name) end
})

return state
