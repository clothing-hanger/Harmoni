-- This is a cleaned up + rewritten version of HUMP.Timer
-- The original license is as follows:
--[[
Copyright (c) 2010-2013 Matthias Richter

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

Except as contained in this notice, the name(s) of the above copyright holders
shall not be used in advertising or otherwise to promote the sale, use or
other dealings in this Software without prior written authorization.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
]]--]]

local pairs = pairs
local max, min = math.max, math.min
local unpack = table.unpack or unpack
local huge = math.huge

local Timer = {}
Timer.__index = Timer

local function _nothing_() end

local function updateTimerHandle(handle, dt)
	local time = handle.time + dt
	handle.time = time

	local limit = handle.limit
	handle.during(dt, max(limit - time, 0))

	local count = handle.count
	while time >= limit and count > 0 do
		if handle.after(handle.after) == false then
			handle.count = 0
			return
		end
		time = time - limit
		count = count - 1
	end

	handle.time = time
	handle.count = count
end

function Timer:update(dt)
	local funcs = self.functions
	local scratch = self._scratch

	for handle in pairs(funcs) do
		scratch[#scratch + 1] = handle
	end

	for i = 1, #scratch do
		local handle = scratch[i]
		if funcs[handle] then
			updateTimerHandle(handle, dt)
			if handle.count == 0 then
				funcs[handle] = nil
			end
		end
		scratch[i] = nil
	end
end

function Timer:during(delay, during, after)
	local handle = {
		time = 0,
		during = during,
		after = after or _nothing_,
		limit = delay,
		count = 1
	}
	self.functions[handle] = true
	return handle
end

function Timer:after(delay, func)
	return self:during(delay, _nothing_, func)
end

function Timer:every(delay, after, count)
	local handle = {
		time = 0,
		during = _nothing_,
		after = after,
		limit = delay,
		count = count or huge
	}
	self.functions[handle] = true
	return handle
end

function Timer:cancel(handle)
	self.functions[handle] = nil
end

function Timer:clear()
	self.functions = {}
end

function Timer:script(f)
	local co
	co = coroutine.wrap(f)
	co(function(t)
		self:after(t, co)
		coroutine.yield()
	end)
end

local tween = {}

tween.out = function(f)
	return function(s, ...) return 1 - f(1 - s, ...) end
end

tween.chain = function(f1, f2)
	return function(s, ...)
		return (s < .5 and f1(2*s, ...) or 1 + f2(2*s-1, ...)) * .5
	end
end

tween.linear = function(s) return s end
tween.quad = function(s) return s*s end
tween.cubic = function(s) return s*s*s end
tween.quart = function(s) return s*s*s*s end
tween.quint = function(s) return s*s*s*s*s end
tween.sine = function(s) return 1 - math.cos(s * math.pi * .5) end
tween.expo = function(s) return 2^(10*(s-1)) end
tween.circ = function(s) return 1 - math.sqrt(1 - s*s) end

tween.back = function(s, b)
	b = b or 1.70158
	return s*s*((b+1)*s - b)
end

tween.bounce = function(s)
	local a, b = 7.5625, 1/2.75
	return min(
		a*s*s,
		a*(s-1.5*b)^2 + .75,
		a*(s-2.25*b)^2 + .9375,
		a*(s-2.625*b)^2 + .984375
	)
end

tween.elastic = function(s, amp, period)
	amp = amp and max(1, amp) or 1
	period = period or .3
	return (-amp * math.sin(2*math.pi/period * (s-1) - math.asin(1/amp)))
	       * 2^(10*(s-1))
end

Timer.tween = setmetatable(tween, {
	__call = function(tween, self, len, subject, target, method, after, ...)
		local payload = {}
		local function collect(s, t)
			for k, v in pairs(t) do
				local ref = s[k]
				assert(type(v) == type(ref), 'Type mismatch in field "'..k..'"')
				if type(v) == 'table' then
					collect(ref, v)
				else
					local delta = v - ref
					payload[#payload+1] = { s, k, delta }
				end
			end
		end

		collect(subject, target)

		method = tween[method or 'linear']
		local args = {...}
		local t, last_s = 0, 0

		return self:during(len, function(dt)
			t = t + dt
			local s = method(min(1, t / len), unpack(args))
			local ds = s - last_s
			last_s = s
			for i = 1, #payload do
				local p = payload[i]
				p[1][p[2]] = p[1][p[2]] + p[3] * ds
			end
		end, after)
	end,

	__index = function(t, key)
		if type(key) == 'function' then return key end
		local v = rawget(t, key)
		if v then return v end

		local out, chain = t.out, t.chain
		local base = key:match('^in%-([^-]+)$')
		          or key:match('^out%-([^-]+)$')
		          or key:match('^in%-out%-([^-]+)$')
		          or key:match('^out%-in%-([^-]+)$')

		assert(base and t[base], 'Unknown interpolation method: '..key)

		if key:find('^out%-') then
			return out(t[base])
		elseif key:find('^in%-out%-') then
			return chain(t[base], out(t[base]))
		elseif key:find('^out%-in%-') then
			return chain(out(t[base]), t[base])
		end

		return t[base]
	end
})

function Timer.new()
	return setmetatable({
		functions = {},
		_scratch = {},
		tween = Timer.tween
	}, Timer)
end

local default = Timer.new()

local module = {}
for k in pairs(Timer) do
	if k ~= "__index" then
		module[k] = function(...) return default[k](default, ...) end
	end
end

module.tween = setmetatable({}, {
	__index = Timer.tween,
	__newindex = function(_, k, v) Timer.tween[k] = v end,
	__call = function(_, ...) return default:tween(...) end,
})

return setmetatable(module, { __call = Timer.new })
