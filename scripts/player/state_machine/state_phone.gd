extends StatePlayer

@export_multiline var dialouge

func enter() -> bool:
	
	player.interact.emit(player.get_global_transform_with_canvas().origin.y, dialouge, Globals.FRIEND_PITCH_SCALE)
	audio_stream_players.crouch.play()
	
	return true

func state_change() -> bool:
	
	if not player.input_disable:
		state_machine.transition(States.STAND_IDLE)
		return true
	
	return false

func process(_delta: float) -> void:
	
	state_change()
	
	return

func exit() -> void:
	
	audio_stream_players.crouch.play()
	
	if state_machine.state_current != self:
		Globals.cutscene_ended = true
	
	return

func _init() -> void:
	
	state = States.PHONE
	
	return
