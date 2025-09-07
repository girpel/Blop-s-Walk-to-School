extends StatePlayerWallJump

var wall_jump_up_delay := false

func enter() -> bool:
	
	if wall_jump_up_delay:
		state_machine.transition(States.WALL_SLIDE_UP)
		return false
	
	wall_jump_up_delay = true
	timers.wall_jump_up_delay.start()
	
	if not super():
		return false
	
	player.wall_jump_up_just_buffer = false
	
	return true

func state_change() -> bool:
	
	state_machine.transition(States.WALL_SLIDE_UP)
	
	return true

func _init() -> void:
	
	super()
	state = States.WALL_JUMP_UP
	
	return

func _on_wall_jump_up_delay_timeout() -> void:
	
	wall_jump_up_delay = false
	
	return
