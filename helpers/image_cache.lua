local ImageCache = {}

function ImageCache.getImage(name)
    local key = name
    if not ImageCache[key] then
        ImageCache[key] = love.graphics.newImage("assets/sprites/"..name..".png")
    end
    return ImageCache[key]
end

---@return love.Image
function preload(name,filter)
    local key = name
    if not ImageCache[key] then
        ImageCache[key] = love.graphics.newImage("assets/sprites/"..name..".png")
        if filter then
            ImageCache[key]:setFilter(filter,filter)
        end
    end
end

return ImageCache