extends Camera2D

func limits_set() -> void:
	
	await owner.ready
	await owner.level.ready
	
	for index in 2:
		for component in 2:
			set_limit(index * 2 + component, owner.level.AREA_RECT.position[component] + owner.level.AREA_RECT.size[component] * index)
	
	return

var current_position := position

func offset_updtae() -> void:
	
	offset.y = 0
	offset.y = -fmod(get_screen_center_position().y, 1)
	
	return

func _ready() -> void:
	
	limits_set()
	
	return

func _physics_process(_delta: float) -> void:
	
	global_position.x = round(global_position.x)
	force_update_scroll()
	
	offset_updtae()
	
	return
