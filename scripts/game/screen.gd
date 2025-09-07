extends Node2D

@onready var camera_2d := $Camera2D
@onready var sub_viewport_camera_2d: Camera2D = owner.get_node($TextureRect.texture.viewport_path).get_camera_2d()

func camera_2d_limit_set() -> void:
	
	for camera_2d_limit_index in 4:
		camera_2d.set_limit(camera_2d_limit_index, sub_viewport_camera_2d.get_limit(camera_2d_limit_index))
	
	return

func position_set() -> void:
	
	position = sub_viewport_camera_2d.global_position
	camera_2d.reset_smoothing()
	
	return

func position_update() -> void:
	
	position = sub_viewport_camera_2d.global_position
	camera_2d.offset = position - sub_viewport_camera_2d.get_screen_center_position()
	
	return

func _ready() -> void:
	
	camera_2d_limit_set()
	position_set()
	
	return

func _physics_process(_delta: float) -> void:
	
	position_update()
	
	return
