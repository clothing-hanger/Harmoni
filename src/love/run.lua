---@diagnostic disable: redundant-parameter, missing-parameter
local threadEvent = love.thread.newThread [[
require "love.event"
require "love.thread"

local pump, poll, getChannel = love.event.pump, love.event.poll, love.thread.getChannel

local channel = {
    event = getChannel("thread.event"),
    active = getChannel("thread.event.active"),
    tick = getChannel("thread.event.tick")
}

local getTime, sleep = love.timer.getTime, love.timer.sleep

local t, s, clock = {}, 0, getTime()
local function push(i, a, ...)
    if a then 
        t[i] = a
        return push(i + 1, ...)
    end

    return i - 1
end

local channel_event = channel.event
local channel_tick = channel.tick
local channel_active = channel.active

repeat v = channel_active:pop()
    if v == 0 then
        break
    elseif v == 1 then
        s = 0
    end

    pcall(pump)
    prev, clock = clock, getTime()
    for name, a, b, c, d, e, f in poll do
        v = push(1, a, b, c, d, e, f)
        channel_event:push(name)
        channel_event:push(clock)
        channel_event:push(v)
        for i = 1, v do
            channel_event:push(t[i])
        end

        v = clock - prev
        s = s + v
        channel_tick:clear()
        channel_tick:push(s)

        sleep(v < 0.001 and 0.001 or 0)
        collectgarbage("step")
    end
until s > 1

]]

local channel_event = love.thread.getChannel("thread.event")
local channel_active = love.thread.getChannel("thread.event.active")

local _, _, flags = love.window.getMode()

-- Don't ask.
love._framerate = flags.refreshrate
love._framerate = love._framerate + (love._framerate % 2) / 2
love._framerate = math.ceil(love._framerate) * 2

love._currentFPS = 0
love._currentTPS = 0

love._drawDT = 0

-- SDL2 = require("Engine.Lib.SDL")

local _

function love.run()
    local love = love
    local arg = arg

    local g_origin, g_clear, g_present = love.graphics.origin, love.graphics.clear, love.graphics.present
    local g_active, g_getBGColour = love.graphics.isActive, love.graphics.getBackgroundColor
    local e_pump, e_poll, t = love.event.pump, love.event.poll, {}
    local t_step = love.timer.step
    local t_getTime = love.timer.getTime
    local a, b
    local dt = 0
    local love_load, love_update, love_draw = love.load, love.update, love.draw
    local love_quit, a_parseGameArguments = love.quit, love.arg.parseGameArguments
    local collectgarbage = collectgarbage
    local love_handlers = love.handlers
    local math = math
    local math_min, math_max = math.min, math.max
    local unpack = unpack

    local channel_active_clear = channel_active.clear
    local channel_active_push = channel_active.push
    local channel_event_pop = channel_event.pop
    local channel_event_demand = channel_event.demand

	love_load(a_parseGameArguments(arg), arg)

	t_step()
    t_step()
    collectgarbage()

    ---@diagnostic disable-next-line: redefined-local
    local function event(name, a, ...)
        if name == "quit" and not love_quit() then
            channel_active_clear(channel_active)
            channel_active_clear(channel_active)
            channel_active_push(channel_active, 0)

            return a or 0, ...
        end

        return love_handlers[name](a, ...)
    end

    local drawTmr = 999999
    local lastDraw = 0
    local draws = 0
    local fpsTimer = 0.0

	return function()
		if threadEvent:isRunning() then
            channel_active_clear(channel_active)
            channel_active_push(channel_active, 1)
            a = channel_event_pop()

            while a do
                b = channel_event_demand()
                for i =  1, b do
                    t[i] = channel_event_demand()
                end
                _, a, b = b, event(a, unpack(t, 1, b))
                if a then
                    e_pump()
                    return a, b
                end
                a = channel_event_pop()
            end
        end

        e_pump()

        ---@diagnostic disable-next-line: redefined-local
        for name, a, b, c, d, e, f in e_poll() do
           a, b = event(name, a, b, c, d, e, f)
           if a then return a, b end
        end

        local cap = love._framerate
        local capDT = 1 / cap

        -- Cap the minimum delta time to 1/30 (30 FPS)
        dt = math_min(t_step(), math_max(capDT, 1 / 30))

        love_update(dt)
        drawTmr = drawTmr + dt
        
        if drawTmr >= capDT then
            if g_active() then
                g_origin()
                g_clear(g_getBGColour())

                love_draw(love._drawDT or 0)

                g_present()

                love._drawDT = t_getTime() - lastDraw
                draws = draws + 1

                fpsTimer = fpsTimer + love._drawDT

                if fpsTimer > 1 then
                    love._currentFPS = draws
                    fpsTimer = fpsTimer % 1
                    draws = 0
                end
                lastDraw = t_getTime()
            end
            drawTmr = drawTmr % capDT
        end

        collectgarbage("step")
    end
end

local o_timer_getFPS = love.timer.getFPS
function love.timer.getFPS()
    return love._currentFPS, o_timer_getFPS()
end

function love.timer.getDrawDelta()
    return love._drawDT
end