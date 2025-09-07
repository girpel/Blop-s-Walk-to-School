extends GPUParticles2D

class_name GPUParticles2DInstance

@onready var parent := get_parent()

func emit() -> void:
	
	var copy := duplicate()
	
	copy.emitting = true
	copy.process_mode = PROCESS_MODE_INHERIT
	
	parent.add_child(copy)
	
	return

func _process(_delta: float) -> void:
	
	if not emitting:
		queue_free()
	
	return
