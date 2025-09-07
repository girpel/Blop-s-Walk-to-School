extends StatePlayerInactive

const TIMERS_SIT_WAIT_TIME_MIN := 15
const TIMERS_SIT_WAIT_TIME_MAX := 20

var sit := false

func enter() -> bool:
	
	if not super():
		return false
	
	if player.jump_just:
		state_machine.transition(States.JUMP)
		return false
	
	if player.crouch:
		
		if player.h_move == 0:
			state_machine.transition(States.CROUCH_IDLE)
			return false
		
		state_machine.transition(States.CROUCH_MOVE)
		return false
	
	if player.h_move != 0:
		state_machine.transition(States.STAND_MOVE)
		return false
	
	sit = false
	timers.sit.start(randf_range(TIMERS_SIT_WAIT_TIME_MIN, TIMERS_SIT_WAIT_TIME_MAX))
	
	return true

func state_change() -> bool:
	
	if super():
		return true
	
	if player.input_disable:
		state_machine.transition(States.INTERACT)
		return true
	
	if sit:
		state_machine.transition(States.SIT)
		return true
	
	return false

func _init() -> void:
	
	state = States.STAND_IDLE
	
	return

func _on_sit_timeout() -> void:
	
	sit = true
	
	return
