local Object = require("classic")
local G = require("globals")

local Ball = Object:extend()

function Ball:new(initX, initY)
    self.pos = {x = initX, y = initY}

    -- Random angle between 0 and 2π
    self.angle = math.random() * math.pi * 2

    self.hit = false
end

function Ball:update(dt)
    -- Move in the direction of the angle
    self.pos.x = self.pos.x + math.cos(self.angle) * G.speed * dt
    self.pos.y = self.pos.y + math.sin(self.angle) * G.speed * dt

    -- Pull toward mouse
    local dx = G.mousePosForPull.x - self.pos.x
    local dy = G.mousePosForPull.y - self.pos.y

    self.pos.x = self.pos.x + dx * G.pullStrength * dt
    self.pos.y = self.pos.y + dy * G.pullStrength * dt

    local w, h = G.bounceArea.w, G.bounceArea.h

    -- Horizontal bounce
-- Vertical walls
if self.pos.x + G.ballRadius > w then
    self.pos.x = w - G.ballRadius
    self.angle = math.pi - self.angle
    self.hit = true

elseif self.pos.x - G.ballRadius < 0 then
    self.pos.x = G.ballRadius
    self.angle = math.pi - self.angle
    self.hit = true
end

-- Horizontal walls
if self.pos.y + G.ballRadius > h then
    self.pos.y = h - G.ballRadius
    self.angle = -self.angle
    self.hit = true

elseif self.pos.y - G.ballRadius < 0 then
    self.pos.y = G.ballRadius
    self.angle = -self.angle
    self.hit = true
end

    if self.hit then self.angle = self.angle + (0.6 * math.random()) - 0.3 end
end

function Ball:draw()
    love.graphics.setColor(0, 0, 0)
    love.graphics.circle("fill", self.pos.x, self.pos.y, G.ballRadius + 3)

    love.graphics.setColor(1, 0, 0)
    love.graphics.circle("fill", self.pos.x, self.pos.y, G.ballRadius)
end

return Ball
