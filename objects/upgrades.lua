local UpgradeData = require("objects.upgradeData")

local Object = require("classic")

local UpgradeBase = Object:extend()
function UpgradeBase:new(upgradeType)
    self.type = upgradeType
    self.title = UpgradeData[upgradeType].title
    self.description = UpgradeData[upgradeType].desc
end

function UpgradeBase:draw(y)
    love.graphics.setColor({0,0,0,1})
    love.graphics.rectangle("fill",5,y+5,250,90)
end

return UpgradeBase