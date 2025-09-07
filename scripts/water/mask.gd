@tool
extends Node2D

@onready var collision_shape_2d := get_parent()
@onready var area_2d_collision_shape_2d := owner.get_node("Area2D/CollisionShape2D")

const COLOR = Color.BLACK

func end_y_calculate() -> float:
	return (area_2d_collision_shape_2d.position + area_2d_collision_shape_2d.shape.size / 2).y

func tool_rect_draw() -> void:
	
	draw_rect(Rect2(collision_shape_2d.shape.a, Vector2(collision_shape_2d.shape.b.x, end_y_calculate())), COLOR)
	
	return

func polygon_draw() -> void:
	
	var polygon: PackedVector2Array = collision_shape_2d.curve_2d.get_baked_points()
	var polygon_end_y := end_y_calculate()
	
	for polygon_index in range(-1, 1):
		polygon.append(Vector2(polygon[polygon_index].x, polygon_end_y))
	
	draw_colored_polygon(polygon, COLOR)
	
	return

func _process(_delta: float) -> void:
	
	queue_redraw()
	
	return

func _draw() -> void:
	
	if Engine.is_editor_hint():
		
		tool_rect_draw()
		
		return
	
	polygon_draw()
	
	return
