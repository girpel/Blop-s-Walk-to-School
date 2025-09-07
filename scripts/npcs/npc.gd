extends AnimatedSprite2D

func _ready() -> void:
	
	frame = int(randf_range(0, sprite_frames.get_frame_count(animation)))
	
	return
