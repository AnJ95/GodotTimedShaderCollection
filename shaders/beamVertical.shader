shader_type canvas_item;

uniform float intensity = 0.5;
uniform float move_y = 100.0;
uniform float scale_x = 1.0;
uniform float fade = 0.0;

void vertex() {
	VERTEX.x *= mix(1.0, 1.0 - intensity, scale_x);
	VERTEX.y -= intensity * move_y;
}

void fragment() {
	COLOR = texture(TEXTURE, UV);
	COLOR.a *= mix(1.0, 1.0 - intensity, fade);
}