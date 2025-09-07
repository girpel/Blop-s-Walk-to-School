extends StatePlayerGround

class_name StatePlayerInactive

func state_change() -> bool:
	
	if super():
		return true
	
	if player.crouch:
		state_machine.transition(States.CROUCH_IDLE)
		return true
	
	if player.h_move != 0:
		state_machine.transition(States.STAND_MOVE)
		return true
	
	return false
