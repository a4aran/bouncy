local geo = {}

function geo.circlesOverlap(a, b)
    local dx = a.x - b.x
    local dy = a.y - b.y
    return dx*dx + dy*dy < (a.r + b.r)^2
end


return geo