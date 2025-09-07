shader_type canvas_item;

global uniform float time_scale;

uniform sampler2D noise_texture : repeat_enable;
uniform vec2 size = vec2(0, 0);
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_nearest;

const vec2 water_strength = vec2(0.0011, 0.0007);
const vec2 noise_scale = vec2(0.002, 0.008);
const vec2 water_speed_1 = vec2(0.09, 0.06);
const vec2 water_speed_2 = vec2(0.08, 0.01);

void fragment() {
	
	vec2 noise_uv = UV * noise_scale * size;
	
	float time = TIME * time_scale;
	
	float noise_1 = texture(noise_texture, noise_uv + time * water_speed_1).r;
	float noise_2 = texture(noise_texture, noise_uv + time * water_speed_2).r;
	
	vec2 water_offset = (noise_1 + noise_2 - 1.0) * 2.0 * water_strength;
	COLOR = texelFetch(SCREEN_TEXTURE, ivec2((SCREEN_UV + water_offset) / SCREEN_PIXEL_SIZE), 0);
}