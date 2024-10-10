#pragma language glsl4

struct Particle {
	vec2 position;
	vec2 velocity;
	vec4 colour;
	float mass;
};

readonly buffer Particles {
	Particle particles[];
};

varying vec4 vertexColour;

#ifdef VERTEX

vec4 position(mat4 loveTransform, vec4 VertexPosition) {
	gl_PointSize = 2.0;
	uint i = love_VertexID;
	Particle particle = particles[i];
	vertexColour = particle.colour;
	return loveTransform * vec4(particle.position, 0.0, 1.0);
}

#endif

#ifdef PIXEL

vec4 effect(vec4 loveColour, sampler2D image, vec2 textureCoords, vec2 screenCoords) {
	return vertexColour;
}

#endif
