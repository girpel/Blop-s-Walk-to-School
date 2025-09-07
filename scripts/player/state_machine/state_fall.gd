extends StatePlayerAir

var floor_buffer := false
var wall_buffer := false

func enter() -> bool:
	
	if state_machine.state_previous is StatePlayerGround:
		floor_buffer = true
		timers.floor_buffer.start()
	
	else:
		floor_buffer = false
	
	if state_machine.state_previous is StatePlayerWallSlide and player.wall_check(player.wall_side, 1):
		
		wall_buffer = true
		timers.wall_buffer.start()
	
	else:
		wall_buffer = false
	
	return true

func state_change() -> bool:
	
	if super():
		return true
	
	if floor_buffer:
		
		if player.jump_just:
			state_machine.transition(States.JUMP)
			return true
	
	if wall_buffer:
		
		if player.jump_just:
			
			state_machine.transition(States.WALL_JUMP_SIDE)
			return true
	
	if player.water > 0:
		
		if player.jump_just:
			state_machine.transition(States.JUMP)
			return true
	
	if player.is_on_floor():
		state_machine.transition(States.STAND_IDLE)
		return true
	
	return false

func _init() -> void:
	
	state = States.FALL
	
	return

func _on_floor_buffer_timeout() -> void:
	
	floor_buffer = false
	
	return

func _on_wall_buffer_timeout() -> void:
	
	wall_buffer = false
	
	return
