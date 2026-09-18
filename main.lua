local G = require("globals")
local SceneManager = require("scenes.scene_manager")
local Game = require("scenes.gameplay")

local ball = {x=200,y=300,r=30,xMult=1,yMult=1,color = {1,0,0}}
math.randomseed(os.time())


function love.load()
    love.window.setMode(1100,800)
    sm = SceneManager()
    sm:addScene(Game(),"gameplay")
end

function love.update(dt)
    sm:update(dt)
    -- ball.x = ball.x + G.speed * dt * ball.xMult  
    -- ball.y = ball.y + G.speed * dt * ball.yMult  

    --triangulate distance to mouse and make it pull the ball


    -- local dx, dy =  mx-ball.x,my-ball.y
    -- ball.x = ball.x + dx * G.pullStrength * dt
    -- ball.y = ball.y + dy * G.pullStrength * dt


    -- local w, h = 800, 800

    -- if ball.x + ball.r > w then
    --     ball.xMult = -1
    --     ball.x = ball.x + 5 * ball.xMult
    --     onHit()
    -- elseif ball.x - ball.r < 0 then
    --     ball.xMult = 1
    --     ball.x = ball.x + 5 * ball.xMult
    --     onHit()

    -- end

    -- if ball.y + ball.r > h then
    --     ball.yMult = -1
    --     ball.y = ball.y + 5 * ball.yMult
    --     onHit()

    -- elseif ball.y - ball.r < 0 then
    --     ball.yMult = 1
    --     ball.y = ball.y + 5 * ball.yMult
    --     onHit()

    -- end
end

function love.draw()
    love.graphics.setBackgroundColor(1,1,1)

    local mx,my = love.mouse.getPosition()
    mx = math.min(mx, 805)
    love.graphics.setLineWidth(5)
    love.graphics.setColor({0,0,0})
    love.graphics.line(mx,my,ball.x,ball.y)
    
    love.graphics.setColor({0,0,0})
    love.graphics.circle("fill",ball.x,ball.y,ball.r+5)
    love.graphics.setColor(ball.color)
    love.graphics.circle("fill",ball.x,ball.y,ball.r)

    love.graphics.setColor({1,1,1})
    local tcx,tcy = ball.x - Self.counterText:getWidth()/2, ball.y - Self.counterText:getHeight()/2
    love.graphics.draw(Self.counterText,tcx,tcy + 5)


    love.graphics.setColor({0,0,0})
    love.graphics.rectangle("fill",800,0,300,800)
end