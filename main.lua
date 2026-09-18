local G = require("globals")

local ball = {x=200,y=300,r=30,xMult=1,yMult=1,color = {1,0,0}}
math.randomseed(os.time())
local counter, counterText = 0, love.graphics.newText(G.font.px50,"0")

local function increasePullStrength()
    if counter >= G.cost.pullStrength then
        counter = counter - G.cost.pullStrength
        G.pullStrength = G.pullStrength + 0.05
        G.cost.pullStrength = math.ceil(G.cost.pullStrength * 1.3)
    end 
end

local function onHit()
    ball.color = {math.random(),math.random(),math.random()}
    counter = counter + 1
    counterText:set(counter)
end

function love.load()
    love.window.setMode(1100,800)
end

function love.update(dt)
    ball.x = ball.x + G.speed * dt * ball.xMult  
    ball.y = ball.y + G.speed * dt * ball.yMult  

    --triangulate distance to mouse and make it pull the ball

    local mx,my = love.mouse.getPosition()
    mx = math.min(mx, 800)
    local dx, dy =  mx-ball.x,my-ball.y
    ball.x = ball.x + dx * G.pullStrength * dt
    ball.y = ball.y + dy * G.pullStrength * dt


    local w, h = 800, 800

    if ball.x + ball.r > w then
        ball.xMult = -1
        ball.x = ball.x + 5 * ball.xMult
        onHit()
    elseif ball.x - ball.r < 0 then
        ball.xMult = 1
        ball.x = ball.x + 5 * ball.xMult
        onHit()

    end

    if ball.y + ball.r > h then
        ball.yMult = -1
        ball.y = ball.y + 5 * ball.yMult
        onHit()

    elseif ball.y - ball.r < 0 then
        ball.yMult = 1
        ball.y = ball.y + 5 * ball.yMult
        onHit()

    end
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
    local tcx,tcy = ball.x - counterText:getWidth()/2, ball.y - counterText:getHeight()/2
    love.graphics.draw(counterText,tcx,tcy + 5)


    love.graphics.setColor({0,0,0})
    love.graphics.rectangle("fill",800,0,300,800)
end