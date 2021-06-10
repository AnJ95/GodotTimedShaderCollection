shader_type canvas_item;

uniform float intensity = 0.5;
uniform float movement_y = 100.0;
uniform float scale_x = 1.0;
uniform float fade_alpha = 0.0;

void vertex() {
	VERTEX.x *= mix(1.0, 1.0 - intensity, scale_x);
	VERTEX.y -= intensity * movement_y;
}

void fragment() {
	COLOR = texture(TEXTURE, UV);
	COLOR.a *= mix(1.0, 1.0 - intensity, fade_alpha);
}