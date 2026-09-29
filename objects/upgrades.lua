local UpgradeData = require("objects.upgradeData")
local G = require("globals")
local Rect = require("helpers.rectangle")
local DeltaTimer = require("helpers.delta_timer")

local Object = require("classic")

local UpgradeBase = Object:extend()
function UpgradeBase:new(upgradeType,pos)
    self.type = upgradeType
    -- self.title = UpgradeData[upgradeType].title
    self.title = "67"
    -- self.description = UpgradeData[upgradeType].desc
    self.rect = Rect(pos.x,pos.y,245,90)
    self.basey = pos.y
    print(self)
    self.hovered = false
    self.visible = true
    self.onClick = print
    self.clickedTimer = DeltaTimer(0.1)
end

function UpgradeBase:scroll(value)
    self.rect.pos.y = self.basey + value
end

function UpgradeBase:draw(y)
    local c = {0.2,0.2,0.2,1}
    if self.clickedTimer:completionPercentage() == 1 then
        if self.hovered then
        c = {1,1,1,1} 
        else
        c = {0.5,0.5,0.5,1}
        end
    end
    love.graphics.setColor(c)
    love.graphics.rectangle("fill",6,y+5,254,90)
end

function UpgradeBase:debug()
    love.graphics.setColor({1,0,0,1})
    love.graphics.setLineWidth(5)
    love.graphics.rectangle("line",self.rect.pos.x,self.rect.pos.y,self.rect.dimensions.x,self.rect.dimensions.y)
end

function UpgradeBase:update(dt)
    self.clickedTimer:update(dt)
    if self.rect.pos.y > 40 then
        self.hovered = self.rect:pointCollide(G.mousePos)
    else 
        self.hovered = false
    end
end

return UpgradeBase