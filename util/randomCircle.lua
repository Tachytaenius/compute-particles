local vec2 = require("lib.mathsies").vec2

local consts = require("consts")

local function randomCircle(radius)
	return math.sqrt(love.math.random()) * radius * vec2.fromAngle(love.math.random() * consts.tau)
end

return randomCircle
