shader_type canvas_item;

// time-dependant intensity supplied by EaseManager
uniform sampler2D intensity_texture;
uniform float intensity_duration;
varying float intensity;

uniform float move_y = 100.0;
uniform float scale_x = 1.0;
uniform float fade = 0.0;


void vertex() {
	float t = mod(TIME, intensity_duration) / intensity_duration;
	intensity = texture(intensity_texture, vec2(t, 0)).r;
	
	VERTEX.x *= mix(1.0, 1.0 - intensity, scale_x);
	VERTEX.y -= intensity * move_y;
}

void fragment() {
	COLOR = texture(TEXTURE, UV);
	COLOR.a *= mix(1.0, 1.0 - intensity, fade);
}