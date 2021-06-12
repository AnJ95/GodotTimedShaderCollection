shader_type canvas_item;

// time-dependant intensity supplied by EaseManager
uniform sampler2D intensity_texture;
uniform float intensity_duration;
uniform bool intensity_loop;
uniform float intensity_time_offset;
varying float intensity;

uniform float period = 1.0;
uniform sampler2D gradient: hint_black;

void vertex() {
	float t = (TIME - intensity_time_offset) / intensity_duration;
	t = intensity_loop ? mod(t, 1.0) : min(t, 1.0);
	intensity = texture(intensity_texture, vec2(t, 0)).r;
}

void fragment() {
	vec4 col_in = texture(TEXTURE, UV);
	vec4 col_grad = texture(gradient, vec2(mod(TIME / period, 1.0), 0.0));
	
	vec4 col_out = mix(col_in, col_in*col_grad, intensity);
	col_out.a = col_in.a;
	
	COLOR = col_out;
}