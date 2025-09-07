extends AudioStreamPlayer2D

class_name AudioStreamsPlayer2D

@export var streams: Array[AudioStream]

func stream_set(stream_index: int) -> void:
	
	stream = streams[stream_index]
	
	return
