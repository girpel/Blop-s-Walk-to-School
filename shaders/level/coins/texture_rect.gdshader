shader_type canvas_item;

void fragment() {
	
	float outline_mult = 1.0;
	
	for (int x = -1; x <= 1; x++){
		for (int y = -1; y <= 1; y++){
			outline_mult *= step(texture(TEXTURE, UV + vec2(float(x), float(y)) * TEXTURE_PIXEL_SIZE).a, 0.0);
		}
	}
	
	float color_a_mult = 1.0 - step(COLOR.a, 0.0);
	COLOR = COLOR * color_a_mult + (1.0 - outline_mult) * (1.0 - color_a_mult) * vec4(0.0, 0.0, 0.0, 1.0);
}
