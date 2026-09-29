local UpgradeData = require("objects.upgradeData")
local G = require("globals")
local Rect = require("helpers.rectangle")

local Object = require("classic")

local UpgradeBase = Object:extend()
function UpgradeBase:new(upgradeType,pos)
    self.type = upgradeType
    -- self.title = UpgradeData[upgradeType].title
    self.title = "67"
    -- self.description = UpgradeData[upgradeType].desc
    self.rect = Rect(pos.x,pos.y,245,90)
    print(self)
    self.hovered = false
end

function UpgradeBase:draw(y)
    local c = {0,0,0,1}
    if self.hovered then c = {1,1,1,1} end
    print(c[1])
    love.graphics.setColor(c)
    love.graphics.rectangle("fill",6,y+5,254,90)
end

function UpgradeBase:debug()
    love.graphics.setColor({1,0,0,1})
    love.graphics.setLineWidth(5)
    love.graphics.rectangle("line",self.rect.pos.x,self.rect.pos.y,self.rect.dimensions.x,self.rect.dimensions.y)
end

function UpgradeBase:update(dt)
    self.hovered = self.rect:pointCollide(G.mousePos)
    if self.hovered then print(self.type) end
end

return UpgradeBase