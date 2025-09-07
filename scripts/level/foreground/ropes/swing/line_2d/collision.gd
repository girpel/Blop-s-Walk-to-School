extends "res://scripts/ropes/line_2d/collision.gd"

@export var streams: Array[AudioStream]

var stream_index := 0 : set = stream_index_set

func stream_index_set(value: int) -> void:
	
	stream_index = value
	stream = streams[stream_index]
	
	return

func play_wrapper(from_position := 0.0) -> void:
	
	stream_index = 1 - stream_index
	
	return super(from_position)
