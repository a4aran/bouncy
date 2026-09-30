local UpgradeData = require("upgradeData")
local G = require("globals")
local Rect = require("helpers.rectangle")
local DeltaTimer = require("helpers.delta_timer")
local fc = require("helpers.font_cache")
local UI = require("ui")

local Object = require("classic")

local UpgradeBase = Object:extend()
function UpgradeBase:new(upgradeType,pos)
    self.type = upgradeType
    self.title = love.graphics.newText(fc.getFont("m6x11",30),UpgradeData.Upgrades[upgradeType].title)
    self.description = UI.TextBlock(UpgradeData.Upgrades[upgradeType].desc,"m6x11",20,0,0,{0,0,0,1},200)
    self.description:useStillPos(true,20,pos.y -55)
    self.rect = Rect(pos.x,pos.y,245,90)
    self.basey = pos.y
    print(self)
    self.hovered = false
    self.visible = true
    self.onClick = print
    self.clickedTimer = DeltaTimer(0.1)
    self.locked = false
end

function UpgradeBase:scroll(value)
    self.rect.pos.y = self.basey + value
end

function UpgradeBase:draw(y)
    local c = {0.2,0.2,0.2,1}
    local offset = 14
    if self.clickedTimer:completionPercentage() == 1 and not self.locked then
        if self.hovered then
        c = {1,1,1,1} 
        offset = 11
        else
        c = {0.5,0.5,0.5,1}
        offset = 16
        end
    end
    love.graphics.setColor(c)
    love.graphics.rectangle("fill",6,y+5,254,90)
    love.graphics.setColor(0,0,0,1)
    love.graphics.draw(self.title,15, y + offset)
    self.description:draw()
end

function UpgradeBase:hoverDraw(x)
    if self.hovered then
        love.graphics.setColor(1,1,0,1)
        love.graphics.rectangle("fill",x-200)
    end
end


function UpgradeBase:debug()
    love.graphics.setColor({1,0,0,1})
    love.graphics.setLineWidth(5)
    love.graphics.rectangle("line",self.rect.pos.x,self.rect.pos.y,self.rect.dimensions.x,self.rect.dimensions.y)
end

function UpgradeBase:update(dt)
    if not self.locked then
        self.clickedTimer:update(dt)
        if self.rect.pos.y > 40 then
            self.hovered = self.rect:pointCollide(G.mousePos)
            print(self.locked)
        else 
            self.hovered = false
        end
    end
end

return UpgradeBase