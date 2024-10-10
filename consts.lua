local consts = {}

consts.tau = math.pi * 2

consts.particleFormat = {
	{name = "position", format = "floatvec2"},
	{name = "velocity", format = "floatvec2"},
	{name = "colour", format = "floatvec4"},
	{name = "mass", format = "float"}
}

consts.drawMeshFormat = {
	{name = "VertexPosition", format = "float"}
}

consts.gravityStrength = 2 -- Gravitational constant

return consts
