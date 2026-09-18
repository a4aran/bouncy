local WelcomeScreen = require("scenes.welcome_screen")
local Object = require("classic")
local SceneManager = Object:extend()

function SceneManager:new()
    self.scenes = {intro = WelcomeScreen()}
    self.currentSceneName = "intro"
end

function SceneManager:addScene(scene,name)
    self.scenes[name] = scene
end

function SceneManager:update(dt)
    if self.scenes[self.currentSceneName].switchScene ~= nil  or G.switch_scene ~= nil then
        local d = self.scenes[self.currentSceneName].switchScene or G.switch_scene
        self.scenes[self.currentSceneName].switchScene = nil
        G.switch_scene = nil
        self.currentSceneName = d
        self.scenes[self.currentSceneName]:onChangedTo()
    end
    self.scenes[self.currentSceneName]:update(dt)
end

function SceneManager:draw()
    self.scenes[self.currentSceneName]:draw()
end

function SceneManager:keypressed(k)
    self.scenes[self.currentSceneName]:keypressed(k)
end
function SceneManager:mousepressed(x, y, button)
    self.scenes[self.currentSceneName]:mousepressed(x, y, button)
end

return SceneManager