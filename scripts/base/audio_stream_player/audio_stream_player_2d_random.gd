extends AudioStreamPlayer2D

class_name AudioStreamPlayer2DRandom

func _ready() -> void:
	
	play(randf_range(0, stream.get_length()))
	
	return
