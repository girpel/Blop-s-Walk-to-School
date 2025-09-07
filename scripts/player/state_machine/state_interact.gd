extends StatePlayerGround

func state_change() -> bool:
	
	if not player.input_disable:
		state_machine.transition(States.STAND_IDLE)
		return true
	
	return super()

func _init() -> void:
	
	state = States.INTERACT
	
	return
