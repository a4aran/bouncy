
local Specials = {
    MousePull = {title = "Mouse Pull", desc = "Ball will now be pulled by mouse. Strength depends on the distance from cursor.", price = 20}
}
local Upgrades = {
    BallSpeed = {
        title = "Ball Speed", 
        desc = "Speed at which balls move",
        max= 15, 
        globalVar = "speed",
        calc = function (amount)
            return 100 + amount * 10
        end,
        price = function (amount)
            return 5 + 3 * amount
        end
    },
    MousePullStrength = {
        title = "Mouse Pull Strength",
        desc = "Increases the pull stregth of the mouse.",
        price = function (amount)
            return 15 * 1.2^amount + amount
        end,
        max= 20,
        globalVar = "mousePullStrength",
        calc = function (amount)
            return 0.1 + 0.044 * amount
        end,
        condition = {special = "MousePull"}
    },
    Ball = {
        title="Add Ball",
        desc="Adds a ball into play",
        max=100,
        calc = function (amount)
            return 1 + amount
        end,
        price = function (amount)
            return 30 + amount^1.3 * 10
        end
    }
}
local UpgradeOrder ={
    "BallSpeed",
    "MousePullStrength"
}

return {Specials = Specials, Upgrades = Upgrades, UpgradeOrder = UpgradeOrder}