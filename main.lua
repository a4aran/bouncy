local G = require("globals")
local SceneManager = require("scenes.scene_manager")
local Game = require("scenes.gameplay")
local Menu = require("scenes.menu")
local vec2 = require("helpers.vec2")

local ball = {x=200,y=300,r=30,xMult=1,yMult=1,color = {1,0,0}}
math.randomseed(os.time())


function love.load()
    love.window.setMode(1100,800,{resizable=false}) -- to read about and fix
    sm = SceneManager()
    sm:addScene(Menu(),"menu")
    sm:addScene(Game(),"gameplay")
end

function love.update(dt)
    local mx, my = love.mouse.getPosition()
    G.mousePos = vec2(mx,my)
    sm:update(dt)
end

function love.draw()
    local dx, dy = love.graphics.getDimensions()
    local scale = {dx/1100,dy/800}
    love.graphics.scale(scale[1],scale[2])
    sm:draw()
end

function love.keypressed(k)
    sm:keypressed(k)
end

function love.mousepressed(x,y,button)
    sm:mousepressed(x, y, button)
end

function love.wheelmoved(x,y)
    sm:scrollwheelmoved(x,y)
end