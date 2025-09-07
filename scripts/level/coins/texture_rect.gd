extends TextureRect

var sub_viewport_camera_2d: Camera2D

func _ready() -> void:
	
	size = Globals.VIEWPORT_SIZE
	sub_viewport_camera_2d = owner.get_node(texture.viewport_path).get_camera_2d()
	
	return

func _physics_process(_delta: float) -> void:
	
	position = sub_viewport_camera_2d.position - size / 2
	
	return
