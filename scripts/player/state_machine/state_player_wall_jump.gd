extends StatePlayerJump

class_name StatePlayerWallJump

var wall_jump_particles: GPUParticles2DInstance

func enter() -> bool:
	
	if not super():
		return false
	
	if state_machine.state_previous.rejump:
		
		gpu_particles_2ds.particles_wall_side_set(wall_jump_particles)
		wall_jump_particles.emit()
		
		timers.v_jump.start()
	
	return true

func _ready() -> void:
	
	wall_jump_particles = gpu_particles_2ds.wall_jump
	
	return

func _on_player_water_entered() -> void:
	
	super()
	wall_jump_particles = gpu_particles_2ds.water_wall_jump
	
	return

func _on_player_water_exited() -> void:
	
	super()
	wall_jump_particles = gpu_particles_2ds.wall_jump
	
	return
