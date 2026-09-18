local Scene = require("scenes.scene")
local G = require("globals")

local Game = Scene:extend()
function Game:new()
    Scene.new(self)
    self.counter, self.counterText = 0, love.graphics.newText(G.font.px50,"0")
end

function Game:update(dt)
    local mx,my = love.mouse.getPosition()
    mx = math.min(mx, 800)
    G.mousePosForPull.x = mx
    G.mousePosForPull.y = my
end

function Game:draw()
    self:setBG({1,1,1,1})
end

function Game:increasePullStrength()
    if self.counter >= G.cost.pullStrength then
        self.counter = self.counter - G.cost.pullStrength
        G.pullStrength = G.pullStrength + 0.05
        G.cost.pullStrength = math.ceil(G.cost.pullStrength * 1.3)
    end 
end

function Game:onHit()
    ball.color = {math.random(),math.random(),math.random()}
    self.counter = self.counter + 1
    Self.counterText:set(self.counter)
end