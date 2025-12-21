-- This is a modified version of the ease library containing micro optimizations
-- https://github.com/poke1024/ease/blob/master/ease.lua

-- ease - a modified remix of flux and bezier-easing.
-- https://github.com/poke1024/ease.git

-- the following code is adapted from flux, Copyright (c) 2016 rxi,
-- https://github.com/rxi/flux/.

local ease = {}

local sin, cos, sqrt, pi = math.sin, math.cos, math.sqrt, math.pi
local abs = math.abs

local base = {}

base.linear = function(p) return p end
base.quad   = function(p) return p * p end
base.cubic  = function(p) return p * p * p end
base.quart  = function(p) return p * p * p * p end
base.quint  = function(p) return p * p * p * p * p end
base.expo   = function(p) return 2^(10 * (p - 1)) end
base.sine   = function(p) return 1 - cos(p * pi * 0.5) end
base.circ   = function(p) return 1 - sqrt(1 - p * p) end
base.back   = function(p) return p * p * (2.7 * p - 1.7) end

local function bounce(p)
	p = 1 - p
	if p < 1 / 2.75 then
		return 1 - 7.5625 * p * p
	elseif p < 2 / 2.75 then
		p = p - 1.5 / 2.75
		return 1 - (7.5625 * p * p + 0.75)
	elseif p < 2.5 / 2.75 then
		p = p - 2.25 / 2.75
		return 1 - (7.5625 * p * p + 0.9375)
	else
		p = p - 2.625 / 2.75
		return 1 - (7.5625 * p * p + 0.984375)
	end
end
base.bounce = bounce

base.elastic = function(p)
	return -(2^(10 * (p - 1)) * sin((p - 1.075) * (pi * 2) / 0.3))
end

local function makeOut(f) -- i would love to do this with super creek 🤤🤤
	return function(p)
		return 1 - f(1 - p)
	end
end

local function makeInOut(f)
	return function(p)
		if p < 0.5 then
			return 0.5 * f(p * 2)
		end
		return 0.5 * (1 - f(2 - p * 2)) + 0.5
	end
end

for name, fn in pairs(base) do
	ease["in-" .. name] = fn
	ease["out-" .. name] = makeOut(fn)
	ease["inout-" .. name] = makeInOut(fn)
end

ease.linear = base.linear

local NEWTON_ITERATIONS = 4
local NEWTON_MIN_SLOPE = 0.001
local SUBDIVISION_PRECISION = 1e-7
local SUBDIVISION_MAX_ITERATIONS = 10

local kSplineTableSize = 11
local kSampleStepSize = 1 / (kSplineTableSize - 1)

local function A(a1, a2) return 1 - 3*a2 + 3*a1 end
local function B(a1, a2) return 3*a2 - 6*a1 end
local function C(a1)     return 3*a1 end

local function calcBezier(t, a1, a2)
	return ((A(a1,a2)*t + B(a1,a2))*t + C(a1))*t
end

local function getSlope(t, a1, a2)
	return 3*A(a1,a2)*t*t + 2*B(a1,a2)*t + C(a1)
end

local function binarySubdivide(x, a, b, x1, x2)
	local t, cur
	for _ = 1, SUBDIVISION_MAX_ITERATIONS do
		t = (a + b) * 0.5
		cur = calcBezier(t, x1, x2) - x
		if abs(cur) <= SUBDIVISION_PRECISION then break end
		if cur > 0 then b = t else a = t end
	end
	return t
end

local function newtonRaphson(x, t, x1, x2)
	for _ = 1, NEWTON_ITERATIONS do
		local slope = getSlope(t, x1, x2)
		if slope == 0 then return t end
		t = t - (calcBezier(t, x1, x2) - x) / slope
	end
	return t
end

local newSamples
if type(jit) == "table" then
	local ffi = require("ffi")
	local spec = "float[" .. (kSplineTableSize + 1) .. "]"
	newSamples = function() return ffi.new(spec) end
else
	newSamples = function() return {} end
end

function ease.cubicbezier(x1, y1, x2, y2)
	assert(x1 >= 0 and x1 <= 1 and x2 >= 0 and x2 <= 1,
		"bezier x values must be in [0,1]")

	if x1 == y1 and x2 == y2 then
		return base.linear
	end

	local samples = newSamples()
	for i = 0, kSplineTableSize - 1 do
		samples[i+1] = calcBezier(i * kSampleStepSize, x1, x2)
	end

	local function getT(x)
		local idx = 1
		local start = 0
		while idx < kSplineTableSize and samples[idx+1] <= x do
			start = start + kSampleStepSize
			idx = idx + 1
		end
		idx = idx - 1

		local dist = (x - samples[idx+1]) / (samples[idx+2] - samples[idx+1])
		local t = start + dist * kSampleStepSize

		local slope = getSlope(t, x1, x2)
		if slope >= NEWTON_MIN_SLOPE then
			return newtonRaphson(x, t, x1, x2)
		elseif slope == 0 then
			return t
		else
			return binarySubdivide(x, start, start + kSampleStepSize, x1, x2)
		end
	end

	return function(x)
		if x == 0 then return 0 end
		if x == 1 then return 1 end
		return calcBezier(getT(x), y1, y2)
	end
end

return ease