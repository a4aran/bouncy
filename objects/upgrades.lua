local Object = require("classic")

local UpgradeBar = Object:expand()
local UpgradeBar:new()
    self.size = {w = 300, h = 800}
    self.upgrades = {}
    self.scrollAmount = 0
end

local UpgradeBar:update(dt) end

local UpgradeBar:draw()
    love.graphics.setColor({0,0,0,0.2})
    love.graphics.rectangle("fill",800,0,self.size.w,self.size.h)
end