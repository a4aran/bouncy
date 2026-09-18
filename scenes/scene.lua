local Object = require("classic")
local Scene = Object:extend()

function Scene:new()
    self.switchScene = nil
    self.bgSet = false
end

function Scene:update(dt) end
function Scene:draw() end
function Scene:keypressed(k) end
function Scene:mousepressed(x, y, button) end

function Scene:requestSceneChange(sceneTochange)
    self.switchScene = sceneTochange
end

function Scene:setBG(color)
    if not self.bgSet then
        love.graphics.setBackgroundColor(color)
        self.bgSet = true
    end
end

function Scene:onChangedTo() end


return Scene