extends AudioStreamPlayer2D

class_name AudioStreamPlayer2DDelay

var play_wait := false

@onready var play_buffer := $PlayBuffer

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

func _on_play_buffer_timeout() -> void:
	
	play_wait = false
	
	return
