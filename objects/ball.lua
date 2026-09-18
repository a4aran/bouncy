local Object = require("classic")
local G = require("globals")

local Ball = Object:extend()
function Ball:new(initX,initY)
    self.pos = {x = initX,y = initY}
    self.posMults = {x = 1, y = 1}
    
    self.hit = false
end

function Ball:update(dt)
    self.pos.x = self.pos.x + G.speed * dt * self.posMults.x  
    self.pos.y = self.pos.y + G.speed * dt * self.posMults.y 

    local dx, dy =  G.mousePosForPull.x - self.pos.x, G.mousePosForPull.y-self.pos.y
    self.pos.x = self.pos.x + dx * G.pullStrength * dt
    self.pos.y = self.pos.y + dy * G.pullStrength * dt

        local w, h = 800, 800

    if self.pos.x + self.pos.r > w then
        self.posMults.x = -1
        self.pos.x = self.pos.x + 5 * self.posMults.x
        self.hit = true
    elseif self.pos.x - self.pos.r < 0 then
        self.posMults.x  = 1
        self.pos.x = self.pos.x + 5 * self.posMults.x
        self.hit = true
    end

    if self.pos.y + self.pos.r > h then
        self.posMults.y = -1
        self.pos.y = self.pos.y + 5 * self.posMults.y
        self.hit = true
    elseif self.pos.y - self.pos.r < 0 then
        self.posMults.y = 1
        self.pos.y = self.pos.y + 5 * self.posMults.y
        self.hit = true
    end
end