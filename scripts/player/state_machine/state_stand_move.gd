extends StatePlayerMove

func state_change() -> bool:
	
	if super():
		return true
	
	if player.h_move == 0:
		state_machine.transition(States.STAND_IDLE)
		return true
	
	if player.crouch:
		state_machine.transition(States.CROUCH_MOVE)
		return false
	
	return false

func _init() -> void:
	
	state = States.STAND_MOVE
	
	return
