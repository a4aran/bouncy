local Object = require("classic")
local Vec2 = require("helpers.Vec2")

local Rect = Object:extend()
function Rect:new(x,y,width,height)
    self.pos = Vec2(x,y)
    self.dimensions = Vec2(width,height)
    print(self.pos)
    print(self.dimensions)
end

function Rect:changePos(newPos)
    self.pos = newPos
end

function Rect:pointCollide(point)
    local px = point.x
    local py = point.y

    return px >= self.pos.x
       and px <= self.pos.x + self.dimensions.x
       and py >= self.pos.y
       and py <= self.pos.y + self.dimensions.y
end

return Rect