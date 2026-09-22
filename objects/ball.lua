local Object = require("classic")
local G = require("globals")

local Ball = Object:extend()
function Ball:new(initX,initY)
    self.pos = {x = initX,y = initY}
    self.posMults = {x = 1, y = 1}
    if math.random() < 0.5 then self.posMults.x = -1 end
    if math.random() < 0.5 then self.posMults.y = -1 end
    
    self.hit = false
end

function Ball:update(dt)
    self.pos.x = self.pos.x + G.speed * dt * self.posMults.x  
    self.pos.y = self.pos.y + G.speed * dt * self.posMults.y 

    local dx, dy =  G.mousePosForPull.x - self.pos.x, G.mousePosForPull.y-self.pos.y
    self.pos.x = self.pos.x + dx * G.pullStrength * dt
    self.pos.y = self.pos.y + dy * G.pullStrength * dt

    local w, h = G.bounceArea.w, G.bounceArea.h

    if self.pos.x + G.ballRadius > w then
        self.posMults.x = -1
        self.pos.x = self.pos.x + 5 * self.posMults.x
        self.hit = true
    elseif self.pos.x - G.ballRadius < 0 then
        self.posMults.x  = 1
        self.pos.x = self.pos.x + 5 * self.posMults.x
        self.hit = true
    end

    if self.pos.y + G.ballRadius > h then
        self.posMults.y = -1
        self.pos.y = self.pos.y + 5 * self.posMults.y
        self.hit = true
    elseif self.pos.y - G.ballRadius < 0 then
        self.posMults.y = 1
        self.pos.y = self.pos.y + 5 * self.posMults.y
        self.hit = true
    end
end

function Ball:draw()
    love.graphics.setColor({0,0,0})
    love.graphics.circle("fill",self.pos.x,self.pos.y,G.ballRadius+3)
    love.graphics.setColor({1,0,0})
    love.graphics.circle("fill",self.pos.x,self.pos.y,G.ballRadius)
end

return Ball