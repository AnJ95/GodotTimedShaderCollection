shader_type canvas_item;

// time-dependant intensity supplied by EaseManager
uniform sampler2D intensity_texture;
uniform float intensity_duration;
varying float intensity;

uniform float period = 1.0;
uniform sampler2D gradient: hint_black;

void vertex() {
	float t = mod(TIME, intensity_duration) / intensity_duration;
	intensity = texture(intensity_texture, vec2(t, 0)).r;
}

void fragment() {
	vec4 col_in = texture(TEXTURE, UV);
	vec4 col_grad = texture(gradient, vec2(mod(TIME / period, 1.0), 0.0));
	
	vec4 col_out = mix(col_in, col_in*col_grad, intensity);
	col_out.a = col_in.a;
	
	COLOR = col_out;
}