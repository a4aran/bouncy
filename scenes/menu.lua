local Scene = require("scenes.scene")
local UI = require("ui")
local ImageCache = require("helpers.image_cache")
local DeltaTimer = require("helpers.delta_timer")
local Vec2 = require("helpers.vec2")

local MainMenu = Scene:extend()
function MainMenu:new()
    Scene.new(self)
    local  dx, dy = love.graphics.getDimensions()
end

function MainMenu:update(dt)
    self.switchScene = "gameplay"
end

function MainMenu:draw()
end

function MainMenu:mousepressed(x,y,button)
end

function MainMenu:keypressed(k)
end

return MainMenu