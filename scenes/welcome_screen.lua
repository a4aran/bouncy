local Scene = require("scenes.scene")
local DeltaTimer = require("helpers.delta_timer")

local WelcomeScreen = Scene:extend()

function WelcomeScreen:new()
    Scene.new(self)
    self.intro = love.graphics.newImage("assets/sprites/made_with_love_white.png")
    self.intro:setFilter("linear","linear")
    self.signature = love.graphics.newImage("assets/sprites/signature.png")
    self.bTimer = DeltaTimer(0.4)
    self.bTimer:restart()
    self.introTimer = DeltaTimer(4)
    self.introStage = 0
    self.introTextureStage = 0
    self.animationStarted = false
    self.destination = "menu" -- change in games
end 

function WelcomeScreen:update(dt)
    self.bTimer:update(dt)
    if not self.bTimer.running and not self.animationStarted then
        self.introTimer:restart()
        self.introStage = 0
        self.introTextureStage = 0
        self.animationStarted = true
    end
    self.introTimer:update(dt)
    if self.introTimer:completionPercentage() >= 0.2 and self.introTimer:completionPercentage() < 0.8 then
        self.introStage = 1
    elseif self.introTimer:completionPercentage() > 0.8 then
        self.introStage = 2
    end
    if self.animationStarted and not self.introTimer.running and self.introTextureStage < 2 then
        self.introTextureStage = 1 + self.introTextureStage
        if self.introTextureStage < 2 then
            self.introTimer:restart()
            self.introStage = 0
        else
            self.switchScene = self.destination
        end
    end
end

function WelcomeScreen:draw()
    self:setBG({0,0,0,1})
    local alpha = 1
    if self.introStage == 0 then
        alpha = 1 - (1 - self.introTimer:completionPercentage()/0.2)^1.17
    elseif self.introStage == 1 then
        alpha = 1
    else
        alpha = math.max((1 - (self.introTimer:completionPercentage()-0.8)/0.15)^1.13,0)
    end
    if not self.animationStarted then
        alpha = 0
    end
    local graf = nil
    if self.introTextureStage == 0 then
        graf = self.intro
    else
        graf = self.signature
    end
    love.graphics.setColor(1,1,1,alpha)
    love.graphics.draw(
        graf,
        love.graphics.getWidth() / 2,   -- x center of screen
        love.graphics.getHeight() / 2,  -- y center of screen
        0,                               -- rotation
        0.5, 0.5,                            -- scale
        graf:getWidth() / 2,          -- x origin offset
        graf:getHeight() / 2          -- y origin offset
    )
end

function WelcomeScreen:keypressed(k)
    if k == "space" then
        self:requestSceneChange("menu")
    end
    
end

return WelcomeScreen