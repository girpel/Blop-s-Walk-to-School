extends AudioStreamPlayer

class_name AudioStreamsPlayer

@export var streams: Array[AudioStream]

func stream_set(stream_index: int) -> void:
	
	if playing:
		await finished
	
	stream = streams[stream_index]
	
	return
