local FontCache = require("helpers.font_cache")
local DeltaTimer = require("helpers.delta_timer")
local ImageCache = require("helpers.image_cache")
local Object = require("classic")

local Button = Object:extend()

function Button:new(text,font,size,centerX,centerY,width,height)
    self.width, self.height = width, height
    self.x = centerX - width / 2
    self.y = centerY - height / 2
    self.state = 1
    self.text = text
    self.font = FontCache.getFont(font,size)
    self.timer = DeltaTimer(0.1)
    self.clickReturned = false
    local w = self.font:getWidth(self.text)
    local h = self.font:getHeight()
    self.tx, self.ty = centerX - w/2, centerY - h/2
    self.down = self.height/15
    self.shadow = {offsetX = self.x + self.width*0.02,offsetY = self.y + self.down,w =self.width - self.width*0.04}
    self.fontColor = {0,0,0,1}
end

function Button:update(dt)
    local mx, my = love.mouse.getPosition()
    self.hovered = mx > self.x and mx < self.x + self.width and 
                   my > self.y and my < self.y + self.height
    if self.state ~= 3 and self.clickReturned then
        self.clickReturned = false
    end
    self.state = self.hovered and 2 or 1
    self.timer:update(dt)
    if self.timer.running then
        self.state = 3
    end
end

function Button:mousepressed(button)
    if button == 1 and self.hovered then
        self.timer:restart()
    end
end

function Button:clicked()
    local r = self.state == 3 and not self.clickReturned and self.timer:completionPercentage() >= 0.75
    if r then
        self.clickReturned = true
    end
    return r
end

function Button:draw()
    -- customise the draw method
    love.graphics.setColor(0,0,0,0.25)
    love.graphics.rectangle("fill",self.shadow.offsetX,self.shadow.offsetY,self.shadow.w,self.height)
    local add_h = 0
    if self.state == 1 then
       love.graphics.setColor(0.9,0.9,0.9,1) 
    elseif self.state == 2 then
        love.graphics.setColor(1,1,1,1) 
    else
        love.graphics.setColor(0.75,0.75,0.75,1) 
        add_h = self.down
    end
    love.graphics.rectangle("fill",self.x,self.y + add_h,self.width,self.height)
    love.graphics.setColor(self.fontColor)
    love.graphics.setFont(self.font)
    love.graphics.print(self.text,self.tx,self.ty + add_h)
end

local ImageButton = Button:extend()

function ImageButton:new(text, font, size, imagePath, centerX, centerY, imageScale)
    local image = ImageCache.getImage(imagePath)
    Button.new(self, text, font, size, centerX, centerY, image:getWidth() * imageScale, image:getHeight() * imageScale)
    self.imageScale = imageScale
    self.image = image
    self.imageTint = {default = {1,1,1,1}, hovered = {1,1,1,1}, pressed = {1,1,1,1}}
end

function ImageButton:draw()
    love.graphics.setColor(0,0,0,0.25)
    love.graphics.draw(self.image,self.x,self.shadow.offsetY,0,self.imageScale,self.imageScale)
    local add_h = 0
    if self.state == 1 then
       love.graphics.setColor(self.imageTint.default) 
    elseif self.state == 2 then
        love.graphics.setColor(self.imageTint.hovered) 
    else
        love.graphics.setColor(self.imageTint.pressed) 
        add_h = self.down
    end
    love.graphics.draw(self.image,self.x,self.y + add_h,0,self.imageScale,self.imageScale)
    love.graphics.setColor(self.fontColor)
    love.graphics.setFont(self.font)
    love.graphics.print(self.text,self.tx,self.ty + add_h)
end

local TextDisplay = Object:extend()

function TextDisplay:new(text,font,size,centerX,centerY,color)
    self.color = color or {0,0,0,1}
    self.font = FontCache.getFont(font,size)
    self.text = text
    self.stillPos = false
    self.pos = {x = centerX - (self.font:getWidth(self.text)/2),y = centerY - (self.font:getHeight()/2)}
    self.c = {x = centerX,y = centerY}
end

function TextDisplay:useStillPos(yn,left,top)
    self.stillPos = yn
    if self.stillPos then
        if left and top then
            self.pos.x = left
            self.pos.y = top
        end
    end
end

function TextDisplay:draw(offsetX,offsetY)
    offsetX = offsetX or 0
    offsetY = offsetY or 0
    love.graphics.setFont(self.font)
    love.graphics.setColor(self.color)
    love.graphics.print(self.text,self.pos.x + offsetX,self.pos.y + offsetY)
end

function TextDisplay:setText(newText)
    if self.text ~= newText then
        self.text = newText
        if not self.stillPos then 
            self.pos = {x = self.c.x - (self.font:getWidth(self.text)/2),y = self.c.y - (self.font:getHeight()/2)}
        end
    end
end

local TextBlock = Object:extend()

function TextBlock:new(text, font, size, centerX, centerY, color, wrapLimit, align)
    self.color = color or {0, 0, 0, 1}
    self.font = FontCache.getFont(font, size)
    self.wrapLimit = wrapLimit or 9999
    self.align = align or "left"
    self.stillPos = false
    self.c = {x = centerX, y = centerY}
    self:setText(text)
end

function TextBlock:_normalise(text)
    if type(text) == "table" then
        return table.concat(text, "\n")
    end
    return text
end

function TextBlock:useStillPos(yn, left, top)
    self.stillPos = yn
    if self.stillPos then
        if left and top then
            self.pos.x = left
            self.pos.y = top
        end
    end
end

function TextBlock:draw(offsetX, offsetY)
    offsetX = offsetX or 0
    offsetY = offsetY or 0
    love.graphics.setFont(self.font)
    love.graphics.setColor(self.color)
    love.graphics.printf(self.text, self.pos.x + offsetX, self.pos.y + offsetY, self.wrapLimit, self.align)
end

function TextBlock:setText(newText)
    local normalised = self:_normalise(newText)
    if self.text ~= normalised then
        self.text = normalised
        if not self.stillPos then
            local _, lines = self.font:getWrap(self.text, self.wrapLimit)
            local totalHeight = #lines * self.font:getHeight() * self.font:getLineHeight()
            local actualWidth = math.min(self.wrapLimit, self.font:getWidth(self.text))
            self.pos = {
                x = self.c.x - (actualWidth / 2),
                y = self.c.y - (totalHeight / 2)
            }
        end
    end
end

local OutlinedTextDisplay = Object:extend()

function OutlinedTextDisplay:new(text, font, size, centerX, centerY, color, outlineSize, outlineColor)
    self.text = text or ""
    self.color = color or {1, 1, 1, 1}
    self.outlineColor = outlineColor or {0, 0, 0, 1}
    self.outlineSize = outlineSize or 2

    self.font = FontCache.getFont(font, size)

    self.c = {x = centerX or 0, y = centerY or 0}
    self.pos = {
        x = self.c.x - (self.font:getWidth(self.text) / 2),
        y = self.c.y - (self.font:getHeight(self.text) / 2)
    }

    self.stillPos = false
end

function OutlinedTextDisplay:useStillPos(yn, left, top)
    self.stillPos = yn

    if self.stillPos and left and top then
        self.pos.x = left
        self.pos.y = top
    elseif not self.stillPos then
        -- revert back to centered mode
        self.pos.x = self.c.x - (self.font:getWidth(self.text) / 2)
        self.pos.y = self.c.y - (self.font:getHeight(self.text) / 2)
    end
end

function OutlinedTextDisplay:setText(newText)
    if self.text ~= newText then
        self.text = newText

        if not self.stillPos then
            self.pos.x = self.c.x - (self.font:getWidth(self.text) / 2)
            self.pos.y = self.c.y - (self.font:getHeight(self.text) / 2)
        end
    end
end

function OutlinedTextDisplay:setCenter(x, y)
    self.c.x = x
    self.c.y = y

    if not self.stillPos then
        self.pos.x = self.c.x - (self.font:getWidth(self.text) / 2)
        self.pos.y = self.c.y - (self.font:getHeight(self.text) / 2)
    end
end

function OutlinedTextDisplay:setOutline(color, size)
    if color then self.outlineColor = color end
    if size then self.outlineSize = size end
end

function OutlinedTextDisplay:draw(offsetX, offsetY)
    offsetX = offsetX or 0
    offsetY = offsetY or 0

    love.graphics.setFont(self.font)

    local x = self.pos.x + offsetX
    local y = self.pos.y + offsetY + self.outlineSize
    local o = self.outlineSize

    -- outline
    love.graphics.setColor(self.outlineColor)

    for dx = -o, o do
        for dy = -o, o do
            if dx ~= 0 or dy ~= 0 then
                love.graphics.print(self.text, x + dx, y + dy)
            end
        end
    end

    -- main text
    love.graphics.setColor(self.color)
    love.graphics.print(self.text, x, y)
end

function OutlinedTextDisplay:setColor(color)
    self.color = color
end


local Bar = Object:extend()

function Bar:new(width,height,posX,posY,fillSide,color,borderColor,borderSize,fillBG)
    self.side = fillSide -- ... 1-4 clockwise by 90deg from 0 (up,right,down,left)
    self.c = color
    self.br = borderColor
    self.bg = fillBG or {1,1,1,0.3} 
    self.fill = 0
    self.pos = {x = posX,y = posY}
    self.s = {w = width, h = height}
    local bs = borderSize or 3
    self.fpos = {x = posX + bs,y = posY + bs}
    self.fs = {w = width - bs*2, h = height - bs*2}
end

function Bar:setValue(val)
    self.fill = val
end

function Bar:getValue()
    return self.fill
end

function Bar:draw()
    -- border
    love.graphics.setColor(self.br)
    love.graphics.rectangle("fill", self.pos.x, self.pos.y, self.s.w, self.s.h)

    -- background (always full)
    love.graphics.setColor(self.bg)
    love.graphics.rectangle("fill", self.fpos.x, self.fpos.y, self.fs.w, self.fs.h)

    -- fill
    love.graphics.setColor(self.c)
    if self.fill >= 1 then
        love.graphics.rectangle("fill", self.fpos.x, self.fpos.y, self.fs.w, self.fs.h)
    elseif self.side == 1 then  -- up
        local fh = self.fs.h * self.fill
        love.graphics.rectangle("fill", self.fpos.x, self.fpos.y + self.fs.h - fh, self.fs.w, fh)
    elseif self.side == 2 then  -- right
        love.graphics.rectangle("fill", self.fpos.x, self.fpos.y, self.fs.w * self.fill, self.fs.h)
    elseif self.side == 3 then  -- down
        love.graphics.rectangle("fill", self.fpos.x, self.fpos.y, self.fs.w, self.fs.h * self.fill)
    elseif self.side == 4 then  -- left
        local fw = self.fs.w * self.fill
        love.graphics.rectangle("fill", self.fpos.x + self.fs.w - fw, self.fpos.y, fw, self.fs.h)
    end
end

local function hexColor(str)
    str = str:gsub("#", "")
    local r = tonumber(str:sub(1,2), 16)
    local g = tonumber(str:sub(3,4), 16)
    local b = tonumber(str:sub(5,6), 16)
    return {r/255, g/255, b/255,1}
end

return {
    Button = Button,
    ImageButton = ImageButton,
    TextDisplay = TextDisplay,
    Bar = Bar,
    hexColor = hexColor,
    TextBlock = TextBlock,
    OutlinedTextDisplay = OutlinedTextDisplay
}