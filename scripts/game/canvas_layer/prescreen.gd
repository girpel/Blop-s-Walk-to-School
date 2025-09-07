extends ColorRect

signal mouse_pressed

@export var mouse_pressed_stream: AudioStream

func mouse_pressed_update(event: InputEvent) -> void:
	
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		
		mouse_pressed.emit()
		
		UIAudioStreamPlayer.play_stream(mouse_pressed_stream)
		
		visible = false
		process_mode = PROCESS_MODE_DISABLED
	
	return

func _input(event: InputEvent) -> void:
	
	mouse_pressed_update(event)
	accept_event()
	
	return
