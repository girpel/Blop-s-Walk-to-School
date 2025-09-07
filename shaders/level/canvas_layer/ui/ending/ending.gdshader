shader_type canvas_item;

uniform vec2 size = vec2(0, 0);
uniform float fade_step : hint_range(0, 1) = 0.0;

const float fade_noise_strength = 2.0;

float random(vec2 coordinates) {
    return fract(sin(dot(coordinates.xy, vec2(12.9898,78.233))) * 43758.5453);
}

void fragment() {

    vec2 uv_scaled = floor(UV * size);
	vec2 uv_snapped = vec2(uv_scaled.x / size.x, uv_scaled.y / size.y);
	
    COLOR.a *= step(uv_snapped.y, fade_step * (fade_noise_strength + 1.0) + (random(uv_snapped) - 1.0) * fade_noise_strength);
}