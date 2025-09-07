extends AudioStreamPlayer

var priority_current := -INF

func _ready() -> void:
	
	process_mode = PROCESS_MODE_ALWAYS
	bus = AudioServer.get_bus_name(Globals.AudioBuses.UI)
	
	finished.connect(_on_finished)
	
	return

func play_stream(audio_stream: AudioStream, priority := 0) -> void:
	
	if priority < priority_current:
		return
	
	priority_current = priority
	
	stream = audio_stream
	play()
	
	return

func _on_finished() -> void:
	
	priority_current = -INF
	
	return
