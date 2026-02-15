local AchievementPopup = Class:extend()

local commonSound = love.audio.newSource("aprilfools/sounds/common.mp3", "static")
local uncommonSound = love.audio.newSource("aprilfools/sounds/uncommon.mp3", "static")
local rareSound = love.audio.newSource("aprilfools/sounds/rare.mp3", "static")
local epicSound = love.audio.newSource("aprilfools/sounds/epic.mp3", "static")
local legendarySound = love.audio.newSource("aprilfools/sounds/legendary.mp3", "static")
local mythicalSound = love.audio.newSource("aprilfools/sounds/mythical.mp3", "static")
local uniqueSound = love.audio.newSource("aprilfools/sounds/unique.mp3", "static")

local function easeOutBack(t)
    local c1 = 1.70158
    local c3 = c1 + 1
    return 1 + c3 * (t - 1)^3 + c1 * (t - 1)^2
end

local function easeOutCubic(t)
    return 1 - (1 - t)^3
end

local function easeInCubic(t)
    return t^3
end

-- some straight fucking BULLLLLLSHITTTTTT

local basePlaqueShader = love.graphics.newShader([[
extern float time;

vec4 effect(vec4 color, Image tex, vec2 tc, vec2 sc)
{
    float t = time;
    float glow = 0.05 * sin(t * 3.0 + sc.x * 5.0);
    vec3 baseColor = vec3(0.1, 0.1, 0.1) + glow;
    return vec4(baseColor * color.rgb, color.a);
}
]])

local legendaryPlaqueShader = love.graphics.newShader([[
extern float time;

vec4 effect(vec4 color, Image tex, vec2 tc, vec2 sc)
{
    float t = time;
    float wave = sin(sc.y * 0.1 + t * 5.0) * 0.05;
    vec3 gold = vec3(1.0, 0.8, 0.2);
    vec3 pulse = gold + vec3(sin(t*10.0), sin(t*12.0), sin(t*14.0)) * 0.1;
    return vec4(pulse * color.rgb, color.a);
}
]])

local mythicalPlaqueShader = love.graphics.newShader([[
extern float time;

vec4 effect(vec4 color, Image tex, vec2 tc, vec2 sc)
{
    float t = time;
    float swirl = sin(sc.x*0.1 + t*4.0) * 0.05;
    vec3 base = vec3(0.1, 0.05, 0.3) + vec3(0.4, 0.2, 0.8) * abs(sin(t*2.0 + sc.y*2.0));
    return vec4(base * color.rgb, color.a);
}
]])

local uniquePlaqueShader = love.graphics.newShader([[
extern float time;
float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

vec4 effect(vec4 color, Image tex, vec2 tc, vec2 sc)
{
    float t = time;
    float noise = rand(sc * 10.0 + floor(t * 5.0));
    vec3 base = vec3(0.05, 0.05, 0.05) + vec3(0.5, 0.1, 0.5) * noise;
    return vec4(base * color.rgb, color.a);
}
]])


local legendaryShader = love.graphics.newShader([[
extern float time;

vec4 effect(vec4 color, Image tex, vec2 tc, vec2 sc)
{
    vec4 texColor = Texel(tex, tc);

    float t = time;

    float distort = sin(sc.y * 0.05 + t * 5.0) * 5.0;
    vec2 warped = tc + vec2(distort / 800.0, 0.0);

    vec4 base = Texel(tex, warped);

    float hue = fract(t * 0.3 + sc.x * 0.002);
    vec3 rainbow = vec3(
        sin(hue * 6.283 + 0.0) * 0.5 + 0.5,
        sin(hue * 6.283 + 2.0) * 0.5 + 0.5,
        sin(hue * 6.283 + 4.0) * 0.5 + 0.5
    );

    float pulse = sin(t * 8.0) * 0.5 + 0.5;

    vec3 goldCore = mix(vec3(1.0, 0.8, 0.2), rainbow, pulse);

    return vec4(goldCore * 1.5, color.a) * base;
}
]])


local mythicalShader = love.graphics.newShader([[
extern float time;
extern bool isText;

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

vec3 hueShift(vec3 c, float a){
    float s = sin(a*6.28318);
    float co = cos(a*6.28318);
    mat3 m = mat3(
        0.299+0.701*co+0.168*s, 0.587-0.587*co+0.330*s, 0.114-0.114*co-0.497*s,
        0.299-0.299*co-0.328*s, 0.587+0.413*co+0.035*s, 0.114-0.114*co+0.292*s,
        0.299-0.300*co+1.250*s, 0.587-0.588*co-1.050*s, 0.114+0.886*co-0.203*s
    );
    return clamp(m*c,0.0,1.5);
}

vec4 effect(vec4 color, Image tex, vec2 tc, vec2 sc)
{
    float t = time;
    vec2 center = vec2(0.5,0.5);
    vec2 d = tc - center;
    float dist = length(d);

    float swirl = sin(dist*8.0 - t*1.0)*0.1;
    float s = sin(swirl);
    float c = cos(swirl);
    vec2 uv = center + vec2(d.x*c - d.y*s, d.x*s + d.y*c);

    float ripple = sin(dist*20.0 - t*3.0)*0.002;
    if (dist > 0.0001)
        uv += normalize(d)*ripple;

    vec4 r = Texel(tex, uv);
    vec4 g = Texel(tex, uv);
    vec4 b = Texel(tex, uv);

    vec4 base = vec4(r.r,g.g,b.b,g.a);

    float hueCycle = fract(t*0.05); 
    base.rgb = hueShift(base.rgb, hueCycle);

    float glow = smoothstep(0.6,0.0,dist);
    base.rgb += glow*0.2;

    float pulse = sin(t*1.5)*0.25 + 0.75;
    base.rgb *= pulse;

    base.rgb *= color.rgb;

    return vec4(base.rgb, color.a) * base;
}
]])


local uniqueShader = love.graphics.newShader([[
extern float time;

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

vec3 hueShift(vec3 color, float shift) {
    float angle = shift * 6.2831853;
    float s = sin(angle);
    float c = cos(angle);
    mat3 m = mat3(
        0.299+0.701*c+0.168*s, 0.587-0.587*c+0.330*s, 0.114-0.114*c-0.497*s,
        0.299-0.299*c-0.328*s, 0.587+0.413*c+0.035*s, 0.114-0.114*c+0.292*s,
        0.299-0.300*c+1.250*s, 0.587-0.588*c-1.050*s, 0.114+0.886*c-0.203*s
    );
    return clamp(m * color, 0.0, 1.5);
}

vec4 effect(vec4 color, Image tex, vec2 tc, vec2 sc)
{
    float t = time;
    vec2 uv = tc;

    float warp1 = sin(sc.y * 0.08 + t * 4.0) * 0.005;
    float warp2 = sin(sc.y * 0.5 + t * 10.0) * 0.002;
    uv.x += warp1 + warp2;

    float split = sin(sc.y * 0.3 + t * 8.0) * 0.001;

    vec4 r = Texel(tex, uv + vec2(split, 0.0));
    vec4 g = Texel(tex, uv);
    vec4 b = Texel(tex, uv - vec2(split, 0.0));

    vec4 base = vec4(r.r, g.g, b.b, g.a);

    vec2 block = floor(sc / 8.0);
    float artifact = step(0.995, rand(block + floor(t*5.0)));

    vec3 corrupt = vec3(
        rand(block + 1.0),
        rand(block + 2.0),
        rand(block + 3.0)
    ) * 0.5;
    base.rgb = mix(base.rgb, corrupt, artifact);

    float brightness = dot(base.rgb, vec3(0.299,0.587,0.114));
    vec2 asciiGrid = floor(tc * vec2(120.0, 70.0));
    float asciiNoise = rand(asciiGrid);
    float asciiMask = step(asciiNoise, brightness);
    base.rgb = mix(base.rgb * 0.8, vec3(brightness), asciiMask);

    float scan = sin(sc.y * 2.0 + t * 10.0) * 0.02;
    base.rgb -= scan;

    float hue = fract(t * 0.2 + rand(sc));
    base.rgb = hueShift(base.rgb, hue);

    return vec4(base.rgb, color.a) * base;
}
]])


function AchievementPopup:new(text, rarity)
    self.text = text
    self.rarity = rarity or "common"
    self.timer = 0
    self.duration = 4
    self.dead = false
    self.phase = "enter"
    self.alpha = 0
    self.scale = 0.6
    self.shakeTriggered = false

    if not self.shakeTriggered then
        if self.rarity == "unique" then
            uniqueSound:clone():play()
        elseif self.rarity == "mythical" then
            mythicalSound:clone():play()
        elseif self.rarity == "legendary" then
            legendarySound:clone():play()
        elseif self.rarity == "epic" then
            epicSound:clone():play()
        elseif self.rarity == "rare" then
            rareSound:clone():play()
        elseif self.rarity == "uncommon" then
            uncommonSound:clone():play()
        else
            commonSound:clone():play()
        end
    end

    if States.game.gameModeManager.inSong then
        States.game.gameModeManager.gameMode:pause(false)
    end
end

function AchievementPopup:update(dt)
    self.timer = self.timer + dt
    local t = self.timer

    if t >= self.duration then
        self.dead = true
        if States.game.gameModeManager.inSong and #AchievementHandler.popupQueue < 1 then
            States.game.gameModeManager.gameMode:unpause(false)
        end
    end

    if t < 0.6 then
        self.phase = "enter"
    elseif t > self.duration - 0.6 then
        self.phase = "exit"
    else
        self.phase = "idle"
    end

    if self.phase == "enter" then
        local p = math.min(t / 0.6, 1)
        local e = easeOutBack(p)
        self.alpha = easeOutCubic(p)
        self.scale = 0.6 + 0.4 * e

        if not self.shakeTriggered then
            if self.rarity == "legendary" then
                CHE:shake(0.5, 15)
            elseif self.rarity == "mythical" then
                CHE:shake(0.8, 25)
            elseif self.rarity == "unique" then
                CHE:shake(1.2, 40)
            end

            if self.rarity == "legendary"
            or self.rarity == "mythical"
            or self.rarity == "unique" then
                self.shakeTriggered = true
            end
        end
    end

    if self.phase == "idle" then
        self.alpha = 1
        self.scale = 1 + math.sin(self.timer * 4) * 0.02
    end

    if self.phase == "exit" then
        local p = math.min((t - (self.duration - 0.6)) / 0.6, 1)
        self.alpha = 1 - easeInCubic(p)
        self.scale = 1 - 0.3 * p
    end
end

function AchievementPopup:draw()
    local w, h = baseScreenRatio.x, baseScreenRatio.y
    local centerX = w * 0.5
    local centerY = h * 0.2

    love.graphics.push()
        love.graphics.translate(centerX, centerY)
        love.graphics.scale(self.scale, self.scale)
        if self.rarity == "unique" then
            local t = love.timer.getTime()
            love.graphics.rotate(math.sin(t * 5) * 0.05)
            love.graphics.translate(math.sin(t * 40) * 5, math.cos(t * 35) * 5)
        elseif self.rarity ~= "common" then
            love.graphics.rotate(math.sin(love.timer.getTime() * 3) * 0.02)
        end

        local boxWidth = w * 0.4
        local boxHeight = h * 0.06 * (math.ceil(self.text:len() / 20))

        local plaqueShaderToUse
        if self.rarity == "legendary" then
            plaqueShaderToUse = legendaryPlaqueShader
        elseif self.rarity == "mythical" then
            plaqueShaderToUse = mythicalPlaqueShader
        elseif self.rarity == "unique" then
            plaqueShaderToUse = uniquePlaqueShader
        else
            plaqueShaderToUse = basePlaqueShader
        end

        plaqueShaderToUse:send("time", love.timer.getTime())
        love.graphics.setShader(plaqueShaderToUse)
        love.graphics.setColor(1, 1, 1, self.alpha)
        love.graphics.rectangle("fill", -boxWidth * 0.5, -boxHeight * 0.5, boxWidth, boxHeight, 20, 20)

        local lastCanvas = love.graphics.getCanvas()
        local textCanvas = self.textCanvas or love.graphics.newCanvas(boxWidth, boxHeight)

        love.graphics.setCanvas(textCanvas)
            love.graphics.clear(0, 0, 0, 0)
            love.graphics.origin()

            love.graphics.setColor(1, 1, 1, self.alpha)
            love.graphics.setShader()
            love.graphics.setFont(SkinHandler:getFont("Menu", 50))
            love.graphics.printf(
                "ACHIEVEMENT UNLOCKED\n" .. self.text,
                0,
                boxHeight * 0.25 - 30,
                boxWidth,
                "center"
            )
        love.graphics.setCanvas(lastCanvas)

        if self.rarity == "legendary" then
            legendaryShader:send("time", love.timer.getTime())
            love.graphics.setShader(legendaryShader)
        elseif self.rarity == "mythical" then
            mythicalShader:send("time", love.timer.getTime())
            love.graphics.setShader(mythicalShader)
        elseif self.rarity == "unique" then
            uniqueShader:send("time", love.timer.getTime())
            love.graphics.setShader(uniqueShader)
        else
            love.graphics.setShader()
        end

        love.graphics.setColor(1, 1, 1, self.alpha)
        love.graphics.push()
            love.graphics.translate(centerX, centerY)
            love.graphics.scale(self.scale, self.scale)
                if self.rarity == "unique" then
                    local t = love.timer.getTime()
                    love.graphics.rotate(math.sin(t * 5) * 0.05)
                    love.graphics.translate(math.sin(t * 40) * 5, math.cos(t * 35) * 5)
                elseif self.rarity ~= "common" then
                    love.graphics.rotate(math.sin(love.timer.getTime() * 3) * 0.02)
                end
            love.graphics.draw(textCanvas, -boxWidth * 0.5, -boxHeight * 0.5)
        love.graphics.pop()

        love.graphics.setShader()
    love.graphics.pop()
end

return AchievementPopup
