extends StatePlayer

class_name StatePlayerGround

var ground_particles: GPUParticles2DInstance

func enter() -> bool:
	
	if state_machine.state_previous is StatePlayerAir:
		timers.ground_particles_pause.call_pause(ground_particles.emit)
		timers.land_audio_stream_pause.call_pause(audio_stream_players.land_ground.play)
	
	elif state_machine.state_previous is StatePlayerWallSlide:
		timers.land_audio_stream_pause.call_pause(audio_stream_players.land_ground.play)
	
	return true

func state_change() -> bool:
	
	if player.jump_just:
		state_machine.transition(States.JUMP)
		return true
	
	if not player.is_on_floor():
		state_machine.transition(States.FALL)
		return true
	
	return false

func physics_process(_delta: float) -> void:
	
	state_change()
	
	return

func _ready() -> void:
	
	ground_particles = gpu_particles_2ds.ground
	
	return

func _on_player_water_entered() -> void:
	
	ground_particles = gpu_particles_2ds.water_ground
	
	return

func _on_player_water_exited() -> void:
	
	ground_particles = gpu_particles_2ds.ground
	
	return
