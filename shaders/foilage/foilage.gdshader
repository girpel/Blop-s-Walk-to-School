shader_type canvas_item;

global uniform float time_scale;

uniform bool stretch_left = false;
uniform bool stretch_right = false;

uniform float wind_strength = 9.0;
uniform float wind_displacement : hint_range(0.0, 1.0) = 1.0;

uniform sampler2D noise_texture : repeat_enable;

const float wind_speed = 0.1;
const float wind_offset = 0.25;
const vec2 noise_scale = vec2(0.025, 0.025);

const float padding_offset_mult = (0.5 - wind_offset);

varying float wind_strength_mult;
varying float padding_mult;

void vertex() {
	
	wind_strength_mult = wind_strength * TEXTURE_PIXEL_SIZE.x;
	padding_mult = wind_strength_mult + 1.0;
	
	VERTEX.x *= padding_mult;
	VERTEX.x += padding_offset_mult * wind_strength;
	
}

void fragment() {
	
	vec2 uv = UV;
	uv.x = uv.x * padding_mult - wind_strength_mult * wind_offset;
	
	vec2 uv_wind = uv;
	uv_wind.x += (wind_offset - texture(noise_texture, UV * noise_scale / TEXTURE_PIXEL_SIZE + TIME * time_scale * wind_speed * vec2(1, 1)).r) * wind_strength * TEXTURE_PIXEL_SIZE.x * (wind_displacement - UV.y);
	
	COLOR = texelFetch(TEXTURE, ivec2(uv_wind / TEXTURE_PIXEL_SIZE), 0) * step(0, uv_wind.x);
	COLOR += texelFetch(TEXTURE, ivec2(vec2(0, uv.y) / TEXTURE_PIXEL_SIZE), 0) * step(0, uv.x) * step(uv_wind.x, 0) * float(stretch_left);
	COLOR += texelFetch(TEXTURE, ivec2(vec2(1, uv.y) / TEXTURE_PIXEL_SIZE - vec2(1, 0)), 0) * step(uv.x, 1) * step(1, uv_wind.x) * float(stretch_right);
}