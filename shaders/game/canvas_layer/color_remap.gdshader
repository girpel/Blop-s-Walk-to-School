shader_type canvas_item;

uniform vec4 color_0 : source_color;
uniform vec4 color_1 : source_color;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_nearest;

void fragment() {
	
	vec4 screen_color = texelFetch(SCREEN_TEXTURE, ivec2(SCREEN_UV / SCREEN_PIXEL_SIZE), 0);
	float screen_color_black = step(screen_color.r, 0.5);
	
	COLOR = color_0 * screen_color_black + color_1 * (1.0 - screen_color_black);
	
}
