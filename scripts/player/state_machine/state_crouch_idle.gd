extends StatePlayerGround

func enter() -> bool:
	
	if not super():
		return false
	
	if state_machine.state_current.state != States.CROUCH_MOVE:
		audio_stream_players.crouch.play() 
	
	return true

func state_change() -> bool:
	
	if super():
		return true
	
	if not player.crouch:
		state_machine.transition(States.STAND_IDLE)
		return true
	
	if player.h_move != 0:
		state_machine.transition(States.CROUCH_MOVE)
		return true
	
	return false

func exit() -> void:
	
	if state_machine.state_current.state != States.CROUCH_MOVE:
		audio_stream_players.crouch.play()
	
	return

func _init() -> void:
	
	state = States.CROUCH_IDLE
	
	return
