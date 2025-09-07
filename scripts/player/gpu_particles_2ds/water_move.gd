extends GPUParticles2DInstance

func _ready() -> void:
	
	Options.particles_collisions_changed.connect(set_visible)
	
	return
