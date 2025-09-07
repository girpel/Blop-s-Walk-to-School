extends StatePlayerInactive

func enter() -> bool:
	
	timers.land_audio_stream_pause.call_pause(audio_stream_players.land_ground.play)
	
	return true

func state_change() -> bool:
	
	if player.input_disable:
		state_machine.transition(States.INTERACT)
		return true
	
	return super()

func _init() -> void:
	
	state = States.SIT
	
	return
