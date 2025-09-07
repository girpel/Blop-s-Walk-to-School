extends AudioStreamPlayer2DDelay

func play_wrapper(from_position := 0.0) -> void:
	
	play(from_position)
	
	return

func play_delay() -> void:
	
	if play_wait:
		return
	
	play_wait = true
	
	play_wrapper()
	play_buffer.start()
	
	return
