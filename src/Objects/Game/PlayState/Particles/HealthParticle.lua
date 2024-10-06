local HealthParticle = Class:extend()

function HealthParticle:new(x, y)
    -- Assuming 'lightDot' is the texture you want to use for the particle
    local image1 = Skin.Particles["Health Particle"]
    image1:setFilter("linear", "linear")
    
    -- Create particle system with the given image
    self.particleSystem = love.graphics.newParticleSystem(image1, 31)
    
    -- Setting up default particle properties (from the original setup)
    self.particleSystem:setColors(1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0.5, 1, 1, 1, 0)
    self.particleSystem:setDirection(-1.5707963705063)  -- Direction is set to -90 degrees (upward)
   -- self.particleSystem:setEmissionArea("borderrectangle", 7, 0.0756, 0, false)
    self.particleSystem:setEmissionRate(0)
    self.particleSystem:setEmitterLifetime(-1)
    self.particleSystem:setInsertMode("top")
    self.particleSystem:setLinearAcceleration(0, 0, 0, 0)
    self.particleSystem:setLinearDamping(0.8, 1)
    self.particleSystem:setOffset(88.39, 90)
    self.particleSystem:setParticleLifetime(0.1187, 0.25)
    self.particleSystem:setRadialAcceleration(0, 0)
    self.particleSystem:setRelativeRotation(false)
    self.particleSystem:setRotation(0, 0)
    self.particleSystem:setSizes(0.14)
    self.particleSystem:setSizeVariation(1)
    self.particleSystem:setSpeed(192.08, 339.72)
    self.particleSystem:setSpin(0, 0)
    self.particleSystem:setSpinVariation(0)
    self.particleSystem:setSpread(0.448)
    self.particleSystem:setTangentialAcceleration(-0.1021, 0)
    
    -- Set the initial position
    self.X = (x+Skin.Params["Health Bar Width"]/2) or Inits.GameWidth/2
    self.Y = y or Inits.GameHeight/2 
    self.particleSystem:setPosition(self.X, self.Y)

    self.min = 20
    self.max = 20  -- Emit 20 particles as defined in the original setup
end

function HealthParticle:update(dt)
    self.particleSystem:update(dt)
end

function HealthParticle:emit()
    -- Emit a fixed number of particles (20 as per the original effect)
    local amount = love.math.random(1,4)
    self.particleSystem:emit(amount)
end

function HealthParticle:draw()
    love.graphics.setBlendMode("add")  -- Set blend mode as specified
    love.graphics.draw(self.particleSystem)
    love.graphics.setBlendMode("alpha")
end

return HealthParticle
