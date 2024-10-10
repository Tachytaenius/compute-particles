struct Particle {
	vec2 position;
	vec2 velocity;
	vec4 colour;
	float mass;
};

buffer InParticles {
	Particle inParticles[];
};
buffer OutParticles {
	Particle outParticles[];
};
uniform uint count;

const float gravityStrength = 1.0;

uniform float dt;

layout(local_size_x = 64, local_size_y = 1, local_size_z = 1) in;
void computemain() {
	uint i = love_GlobalThreadID.x;
	if (i >= count) {
		return;
	}

	Particle particle = inParticles[i];
	vec2 force = vec2(0.0);
	for (uint j = 0; j < count; j++) {
		if (i == j) {
			continue;
		}
		Particle otherParticle = inParticles[j];
		vec2 difference = otherParticle.position - particle.position;
		float dist = length(difference);
		if (dist == 0.0) {
			continue;
		}
		vec2 direction = difference / dist;
		force += direction * gravityStrength * particle.mass * otherParticle.mass * pow(dist, -1.0);
	}
	vec2 accel = force / particle.mass;
	particle.velocity += accel * dt;
	particle.position += particle.velocity * dt;

	outParticles[i] = particle;
}