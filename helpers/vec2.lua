-- vec2.lua
local Vec2 = {}
Vec2.__index = Vec2

function Vec2.new(x, y)
    return setmetatable({x = x or 0, y = y or 0}, Vec2)
end

function Vec2:length()
    return math.sqrt(self.x * self.x + self.y * self.y)
end

function Vec2:normalized()
    local len = self:length()
    if len == 0 then return Vec2.new(0, 0) end
    return Vec2.new(self.x / len, self.y / len)
end

setmetatable(Vec2, {
    __call = function(_, x, y) return Vec2.new(x, y) end
})

function Vec2:__add(other) return Vec2.new(self.x + other.x, self.y + other.y) end
function Vec2:__sub(other) return Vec2.new(self.x - other.x, self.y - other.y) end
function Vec2:__mul(s)     return Vec2.new(self.x * s, self.y * s) end
function Vec2:__div(s) return Vec2.new(self.x / s, self.y / s) end
function Vec2:__tostring()
    return string.format("(%.3f, %.3f)", self.x, self.y)
end
function Vec2:angleTo(other)
    return math.atan2(other.y - self.y, other.x - self.x)
end
function Vec2.fromAngle(angle)
    return Vec2.new(math.cos(angle), math.sin(angle))
end

return Vec2