ring = love.graphics.newImage("Images/PARTICLES/ring.png")
ring:setFilter("linear", "linear")

splash = love.graphics.newParticleSystem(ring, 3)
splash:setColors(0.265625, 0, 1, 1, 0.7109375, 0, 1, 0.71875, 0, 0.15625, 1, 1, 0.1484375, 0, 1, 1)
splash:setDirection(-1.5707963705063)
splash:setEmissionArea("none", 0, 0, 0, false)
splash:setEmissionRate(0)
splash:setEmitterLifetime(0)
splash:setInsertMode("top")
splash:setLinearAcceleration(0, 5000, 0, 1290.2551269531)
splash:setLinearDamping(4.1745858192444, 1.8424195051193)
splash:setOffset(50, 50)
splash:setParticleLifetime(0.21165879070759, 0.36076718568802)
splash:setRadialAcceleration(-0.91865795850754, 0.10207310318947)
splash:setRelativeRotation(false)
splash:setRotation(-0.008333140052855, 0)
splash:setSizes(0.40000000596046)
splash:setSizeVariation(0)
splash:setSpeed(372.05645751953, 908.87933349609)
splash:setSpin(0, 0)
splash:setSpinVariation(0)
splash:setSpread(6.2831854820251)
splash:setTangentialAcceleration(0, 0)
-- At start time:
-- splash:start()
-- splash:emit(3)
-- At draw time:
-- love.graphics.setBlendMode("add")
-- love.graphics.draw(splash, 0+0, 0+0)
