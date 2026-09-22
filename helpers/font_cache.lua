local FontCache = {}

function FontCache.getFont(name, size)
    local key = name .. tostring(size)
    if not FontCache[key] then
        FontCache[key] = love.graphics.newFont("assets/fonts/"..name..".ttf", size)
    end
    return FontCache[key]
end

return FontCache