local Object = require("classic")
local DeltaTimer = Object:extend()

function DeltaTimer:new(countdownTime)
    self.countdownTime = countdownTime
    self.time = 0
    self.running = false
end

function DeltaTimer:update(dt)
    if self.running then
        self.time = self.time + dt
        if self.time > self.countdownTime then
            self.running = false
            self.time = 0
        end
    end
end

function DeltaTimer:completionPercentage()
    if not self.running then return 1 end
    return self.time / self.countdownTime
end

function DeltaTimer:restart()
    self.time = 0
    self.running = true
end

function DeltaTimer:reset()
    self.time = 0
    self.running = false
end

function DeltaTimer:leftTime()
    return math.max(self.countdownTime - self.time,0)
end

return DeltaTimer