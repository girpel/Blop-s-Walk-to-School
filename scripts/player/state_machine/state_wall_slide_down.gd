extends StatePlayerWallSlide

func physics_process(_delta: float) -> void:
	
	state_change()
	
	return

func exit() -> void:
	
	exit_wall_slide()
	
	return

func _init() -> void:
	
	state = States.WALL_SLIDE_DOWN
	v_speed_max_mult = 0.25
	
	return
