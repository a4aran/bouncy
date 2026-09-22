local G = require("globals")
local SceneManager = require("scenes.scene_manager")
local Game = require("scenes.gameplay")
local Menu = require("scenes.menu")

local ball = {x=200,y=300,r=30,xMult=1,yMult=1,color = {1,0,0}}
math.randomseed(os.time())


function love.load()
    love.window.setMode(1100,800)
    sm = SceneManager()
    sm:addScene(Menu(),"menu")
    sm:addScene(Game(),"gameplay")
end

function love.update(dt)
    sm:update(dt)
end

function love.draw()
    sm:draw()
end

function love.keypressed(k)
    sm:keypressed(k)
end

function love.mousepressed(x, y, button)
    sm:mousepressed(x, y, button)
end