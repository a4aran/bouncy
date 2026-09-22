local Scene = require("scenes.scene")
local G = require("globals")
local UI = require("ui")
local Ball = require("objects.ball")

local Game = Scene:extend()
function Game:new()
    Scene.new(self)
    self.counter, self.counterText = 0, UI.TextDisplay("0","m6x11",96,G.bounceArea.w/2,75,{0,0,0})
    self.balls = {}
    for i = 1, 100, 1 do
        table.insert(self.balls,Ball(100 + 600 * math.random(),100 + 600 * math.random()))
    end
end

function Game:update(dt)
    local mx,my = love.mouse.getPosition()
    mx = math.min(mx, 800)
    G.mousePosForPull.x = mx
    G.mousePosForPull.y = my
    for key, value in pairs(self.balls) do
        value:update(dt)
        if value.hit then self:onHit(value) end
    end
end

function Game:draw()
    self:setBG({1,1,1,1})
    love.graphics.setColor({0,0,0,0.2})
    love.graphics.rectangle("fill",800,0,300,800)
    for key, value in pairs(self.balls) do
        value:draw()
    end
    self.counterText:draw()
end

function Game:increasePullStrength()
    if self.counter >= G.cost.pullStrength then
        self.counter = self.counter - G.cost.pullStrength
        G.pullStrength = G.pullStrength + 0.05
        G.cost.pullStrength = math.ceil(G.cost.pullStrength * 1.3)
    end 
end

function Game:onHit(ball)
    self.counter = self.counter + 1
    self.counterText:setText(self.counter)
    ball.hit = false
end

return Game