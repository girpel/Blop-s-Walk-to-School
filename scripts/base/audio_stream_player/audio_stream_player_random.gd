extends AudioStreamPlayer

class_name AudioStreamPlayerRandom

func _ready() -> void:
	
	play(randf_range(0, stream.get_length()))
	
	return
