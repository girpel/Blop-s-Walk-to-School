extends Node

const AMBIENCE_OUTSIDE_DISTANCE_MAX := 200

var area_2ds_rects: Array[Rect2]

func collision_shape_2d_shapes_set() -> void:
	
	for area_2d in get_children():
		
		var collision_shape_2d: CollisionShape2D = area_2d.shape_owner_get_owner(0)
		area_2ds_rects.append(Rect2(collision_shape_2d.position - collision_shape_2d.shape.size / 2, collision_shape_2d.shape.size))
	
	return

func ambience_volume_db_update() -> void:
	
	var areas_2ds_rects_distance := INF
	
	for area_2d_rect in area_2ds_rects:
		
		var area_2d_rect_difference_start := area_2d_rect.position - Globals.player.position
		var area_2d_rect_difference_end := Globals.player.position - area_2d_rect.end
		
		var area_2d_rect_difference := Vector2.ZERO
		
		for component in range(2):
			area_2d_rect_difference[component] = max(0, area_2d_rect_difference_start[component], area_2d_rect_difference_end[component])
		
		areas_2ds_rects_distance = min(areas_2ds_rects_distance, area_2d_rect_difference.length()) 
	
	var ambience_inside_volume_linear := smoothstep(0, AMBIENCE_OUTSIDE_DISTANCE_MAX, areas_2ds_rects_distance)
	
	AudioServer.set_bus_volume_db(Globals.AudioBuses.AMBIENCE_INSIDE, linear_to_db(ambience_inside_volume_linear))
	AudioServer.set_bus_volume_db(Globals.AudioBuses.AMBIENCE_OUTSIDE, linear_to_db(1 - ambience_inside_volume_linear))
	
	return

func _ready() -> void:
	
	collision_shape_2d_shapes_set()
	AudioServer.set_bus_volume_db(Globals.AudioBuses.AMBIENCE_INSIDE, Globals.VOLUME_DB_MAX)
	
	return

func _process(_delta: float) -> void:
	
	ambience_volume_db_update()
	
	return

func _on_area_2d_body_entered(_body: Node2D) -> void:
	
	set_process(false)
	
	AudioServer.set_bus_volume_db(Globals.AudioBuses.AMBIENCE_OUTSIDE, 0)
	AudioServer.set_bus_volume_db(Globals.AudioBuses.AMBIENCE_INSIDE, Globals.VOLUME_DB_MIN)
	
	return

func _on_area_2d_body_exited(_body: Node2D) -> void:
	
	set_process(true)
	
	return
