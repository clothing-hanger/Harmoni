lineParticle = love.graphics.newImage("Images/PARTICLES/line.png")
lineParticle:setFilter("linear", "linear")

comboAlertLines = love.graphics.newParticleSystem(lineParticle, 3)
comboAlertLines:setColors(1, 1, 1, 1)
comboAlertLines:setDirection(0)
comboAlertLines:setEmissionArea("none", 0, 0, 0, false)
comboAlertLines:setEmissionRate(0)
comboAlertLines:setEmitterLifetime(0)
comboAlertLines:setInsertMode("top")
comboAlertLines:setLinearAcceleration(0, 0, 0, 0)
comboAlertLines:setLinearDamping(1.4063632488251, 2.6067428588867)
comboAlertLines:setOffset(50, 2)
comboAlertLines:setParticleLifetime(0.7551776766777, 0.20006328821182)
comboAlertLines:setRadialAcceleration(0, 0)
comboAlertLines:setRelativeRotation(false)
comboAlertLines:setRotation(0, 0)
comboAlertLines:setSizes(1)
comboAlertLines:setSizeVariation(0)
comboAlertLines:setSpeed(-1433.6166992188, -1589.0944824219)
comboAlertLines:setSpin(0, 0)
comboAlertLines:setSpinVariation(0)
comboAlertLines:setSpread(0.32911923527718)
comboAlertLines:setTangentialAcceleration(0, 0)
-- At start time:
-- comboAlertLines:start()
-- comboAlertLines:emit(3)
-- At draw time:
-- love.graphics.setBlendMode("add")
-- love.graphics.draw(comboAlertLines, -572+0, -185+0)
