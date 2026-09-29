local Object = require("classic")
local UI = require("ui")
local upgrades = require("objects.upgrades")

local UpgradeBar = Object:extend()
function UpgradeBar:new()
    self.size = {w = 300, h = 800}
    self.title = UI.TextDisplay("UPGRADES","m6x11",64,950,64,{0,0,0})
    self.upgrades = {}
    for i = 1, 10, 1 do
        table.insert(self.upgrades,upgrades("no"))
    end
    self.scrollAmount = 0
    self.scrollCanvas = love.graphics.newCanvas(250,675)
end

function UpgradeBar:update(dt) end

function UpgradeBar:draw()
    love.graphics.setColor({0,0,0,0.2})
    love.graphics.rectangle("fill",800,0,self.size.w,self.size.h)
    love.graphics.rectangle("fill",820,100,self.size.w-40,self.size.h - 120)

    love.graphics.setCanvas(self.scrollCanvas)
    love.graphics.clear(0, 0, 0, 0)
    -- love.graphics.setScissor(0,0,250,650)
    for i=0, #self.upgrades-1, 1 do
        self.upgrades[i+1]:draw(100*i)
    end
    love.graphics.setCanvas()
    love.graphics.setScissor( )
    love.graphics.draw(self.scrollCanvas,820,100)
    self.title:draw()
end

return {UpgradeBar = UpgradeBar}