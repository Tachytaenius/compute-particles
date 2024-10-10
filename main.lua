local vec2 = require("lib.mathsies").vec2

local consts = require("consts")
local randomCircle = require("util.randomCircle")

local particleSimulationShader
local particleRenderingShader

local particleCount
local inParticleBuffer, outParticleBuffer

local drawMesh

function love.load()
	particleSimulationShader = love.graphics.newComputeShader("shaders/particleSimulation.glsl")
	particleRenderingShader = love.graphics.newShader("shaders/particleRendering.glsl")

	particleCount = 10000
	inParticleBuffer = love.graphics.newBuffer(consts.particleFormat, particleCount, {shaderstorage = true})
	outParticleBuffer = love.graphics.newBuffer(consts.particleFormat, particleCount, {shaderstorage = true})

	local particleData = {}
	local positionRadius = 0.4 * math.min(love.graphics.getDimensions()) / 2
	local centre = vec2(love.graphics.getDimensions()) / 2
	for i = 1, particleCount do
		local position = centre + randomCircle(positionRadius)
		local noiseFrequency = 0.03125
		local noiseAmplitude = 25
		local noiseX = noiseAmplitude * (love.math.simplexNoise(position.x * noiseFrequency, position.y * noiseFrequency, 0) * 2 - 1)
		local noiseY = noiseAmplitude * (love.math.simplexNoise(position.x * noiseFrequency, position.y * noiseFrequency, 2) * 2 - 1)
		position = position + vec2(noiseX, noiseY)
		local velocity = randomCircle(0)
		particleData[i] = {
			position.x, position.y,
			velocity.x, velocity.y,
			1, 1, 1, 0.125,
			1
		}
	end
	outParticleBuffer:setArrayData(particleData) -- Gets swapped immediately

	drawMesh = love.graphics.newMesh(consts.drawMeshFormat, particleCount, "points")
end

function love.update(dt)
	inParticleBuffer, outParticleBuffer = outParticleBuffer, inParticleBuffer

	particleSimulationShader:send("count", particleCount)
	-- particleSimulationShader:send("gravityStrength", consts.gravityStrength)
	particleSimulationShader:send("InParticles", inParticleBuffer)
	particleSimulationShader:send("OutParticles", outParticleBuffer)
	particleSimulationShader:send("dt", dt)

	local groupCount = math.ceil(particleCount / particleSimulationShader:getLocalThreadgroupSize())
	love.graphics.dispatchThreadgroups(particleSimulationShader, groupCount)
end

function love.draw()
	love.graphics.setShader(particleRenderingShader)
	particleRenderingShader:send("Particles", outParticleBuffer)
	love.graphics.draw(drawMesh)
	love.graphics.setShader()

	love.graphics.print(love.timer.getFPS())
end
