shader_type canvas_item;

const float PI2 = 6.2831853072;

// time-dependant intensity supplied by EaseManager
uniform sampler2D intensity_texture;
uniform float intensity_duration;
varying float intensity;

uniform float ampl_0 = 0.0;
uniform float ampl_1 = 10.0;
uniform float period_0 = 20.0;
uniform float period_1 = 20.0;
uniform float time_flow = 0.0;
uniform float offset = 0.0;

varying vec2 v;
void vertex() {
	v = VERTEX;
	float t = mod(TIME, intensity_duration) / intensity_duration;
	intensity = texture(intensity_texture, vec2(t, 0)).r;
}

void fragment() {
	float ampl = mix(ampl_0, ampl_1, intensity) * TEXTURE_PIXEL_SIZE.y;
	float period = mix(period_0, period_1, intensity);
	vec2 uv = UV;
	uv.y += ampl * sin(PI2 * (offset + time_flow*TIME + v.x / period));
	COLOR = texture(TEXTURE, uv);
}