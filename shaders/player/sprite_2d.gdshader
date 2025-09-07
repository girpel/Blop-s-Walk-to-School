shader_type canvas_item;

uniform vec2 scale;
uniform vec2 offset;

void vertex() {
	
	VERTEX *= scale;
	VERTEX += offset;
	
}