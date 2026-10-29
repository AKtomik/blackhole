shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

uniform vec2 center;
uniform float force;

void fragment() {
	vec2 disp = normalize(UV - center) * force;
	COLOR = vec4(UV - disp, 0.0, 1.0);
	COLOR = texture(TEXTURE, UV - disp);

}