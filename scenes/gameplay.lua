local Scene = require("scenes.scene")
local G = require("globals")
local UI = require("ui")
local Ball = require("objects.ball")
local Upgrades = require("objects.upgradeBar")

local Game = Scene:extend()
function Game:new()
    Scene.new(self)
    self.counterText = UI.OutlinedTextDisplay("0","m6x11",96,G.bounceArea.w/2,75,{1,1,1},3,{0,0,0})
    self.balls = {}
    for i = 1, 1, 1 do
        table.insert(self.balls,Ball(100 + 600 * math.random(),100 + 600 * math.random()))
    end
    self.upgardeBar = Upgrades.UpgradeBar()
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
    self.upgardeBar:update(dt)
end

function Game:draw()
    self:setBG({1,1,1,1})
    for key, value in pairs(self.balls) do
        value:draw()
    end
    self.counterText:draw()
    self.upgardeBar:draw()
end

-- function Game:increasePullStrength()
--     if self.counter >= G.cost.pullStrength then
--         self.counter = self.counter - G.cost.pullStrength
--         G.pullStrength = G.pullStrength + 0.05
--         G.cost.pullStrength = math.ceil(G.cost.pullStrength * 1.3)
--     end 
-- end

function Game:onHit(ball)
    G.counter = G.counter + 1
    self.counterText:setText(G.counter)
    self.upgardeBar:counterChange()
    ball.hit = false
end

function Game:scrollwheelmoved(x,y)
    self.upgardeBar:changeScroll(y)
end

function Game:mousepressed(x,y,btn)
    self.upgardeBar:mousepressed(x,y,btn)
end

return Game