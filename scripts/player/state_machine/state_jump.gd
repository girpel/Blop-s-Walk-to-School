extends StatePlayerJump

const JUMP_TRANSITION_VELOCITY_Y := -140

var ground_particles: GPUParticles2DInstance

func enter() -> bool:
	
	if not super():
		return false
	
	if state_machine.state_previous.rejump:
		
		timers.ground_particles_pause.call_pause(ground_particles.emit)
		timers.v_jump.start()
	
	elif timers.v_jump.is_stopped():
		v_jump = false
	
	return true

func state_change() -> bool:
	
	if super():
		return true
	
	if player.water > 0:
		
		if player.jump_just and (not Options.jump_hold or player.velocity.y > JUMP_TRANSITION_VELOCITY_Y):
			state_machine.transition(States.JUMP)
			return true
	
	return false

func _init() -> void:
	
	super()
	rejump = true
	
	state = States.JUMP
	
	
	return

func _ready() -> void:
	
	ground_particles = gpu_particles_2ds.ground
	
	return

func _on_player_water_entered() -> void:
	
	super()
	ground_particles = gpu_particles_2ds.water_ground
	
	return

func _on_player_water_exited() -> void:
	
	super()
	ground_particles = gpu_particles_2ds.ground
	
	return
