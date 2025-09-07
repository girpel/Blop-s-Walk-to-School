extends StatePlayer

class_name StatePlayerAir

func state_change() -> bool:
	
	if player.wall_next and (player.wall_side * player.h_move == -1 or (player.wall_side == -sign(player.get_real_velocity().x) and player.wall_side * player.h_move != 1)):
		
		state_machine.transition(States.WALL_SLIDE_UP)
		
		return true
	
	return false

func physics_process(_delta: float) -> void:
	
	state_change()
	
	return

func _init() -> void:
	
	h_deceleration_mult = 2
	
	return
