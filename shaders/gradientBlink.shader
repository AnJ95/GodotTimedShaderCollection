shader_type canvas_item;

uniform float intensity = 0.5;
uniform float period = 1.0;
uniform sampler2D gradient: hint_black;


void fragment() {
	vec4 col_in = texture(TEXTURE, UV);
	vec4 col_grad = texture(gradient, vec2(mod(TIME / period, 1.0), 0.0));
	
	vec4 col_out = mix(col_in, col_in*col_grad, intensity);
	col_out.a = col_in.a;
	
	COLOR = col_out;
}