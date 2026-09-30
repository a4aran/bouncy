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
    self.price = UpgradeData.Upgrades[upgradeType].price(G.upgradesBought.Upgrades[upgradeType])
    self.priceText = love.graphics.newText(fc.getFont("m6x11",35), self.price.."$")
    self.rect = Rect(pos.x,pos.y,245,90)
    self.basey = pos.y
    self.hovered = false
    self.visible = true
    self.onClick = 
    self.clickedTimer = DeltaTimer(0.1)
    self.hoverTimer = DeltaTimer(0.3)
    self.hoverAnimationPlayed = false
    self.locked = false
    
    self.description = UI.TextBlock(UpgradeData.Upgrades[upgradeType].desc,"m6x11",20,0,0,{0,0,0,1},220)
    self.description:useStillPos(true,10,20)
    self.infoCanva = love.graphics.newCanvas(240,180)
    love.graphics.setCanvas(self.infoCanva)
    love.graphics.setColor(1,1,0,1)
    love.graphics.rectangle("fill",0,0,240,180)
    self.description:draw()
    love.graphics.setCanvas()
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
    if not self.locked then
        local priceColor = {0.6,0,0,1}
        if G.counter >= self.price then
            priceColor[1] = 0
            priceColor[2] = 1
        end
        love.graphics.setColor(priceColor)
        love.graphics.draw(self.priceText,25, y + offset + 35)
    end
end

function UpgradeBase:hoverDraw(x)
    if self.hovered then
        love.graphics.setColor(1,1,1,self.hoverTimer:completionPercentage())
        love.graphics.draw(self.infoCanva,x-245,self.rect.pos.y - 40)
        -- love.graphics.rectangle("fill",x-245,self.rect.pos.y-40,240,180)
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
        self.hoverTimer:update(dt)
        if self.rect.pos.y > 40 then
            self.hovered = self.rect:pointCollide(G.mousePos)
        else 
            self.hovered = false
        end
        if self.hovered then
        if not self.hoverAnimationPlayed then
            self.hoverTimer:restart()
            self.hoverAnimationPlayed = true
        end
        else 
        self.hoverAnimationPlayed = false
        end
    end
end

return UpgradeBase