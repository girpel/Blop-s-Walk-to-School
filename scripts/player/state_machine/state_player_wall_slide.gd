extends StatePlayer

class_name StatePlayerWallSlide

const WALL_SLIDE_PARTICLES_DELAY_WAIT_TIME := 0.05
const WATER_WALL_SLIDE_PARTICLES_DELAY_WAIT_TIME := 0.085

var move_buffer := true
var wall_jump_up_transition := true

var wall_slide_particles: GPUParticles2DInstance

func enter_wall_jump() -> bool:
	
	if player.wall_jump_up_just:
		
		if wall_jump_up_transition and timers.wall_jump_up_delay.is_stopped():
			state_machine.transition(States.WALL_JUMP_UP)
			return true
	
	elif player.jump_just_buffer:
		state_machine.transition(States.WALL_JUMP_SIDE)
		return true
	
	return false

func exit_wall_slide() -> void:
	
	audio_stream_players.wall_slide.stop()
	timers.wall_slide_particles_delay.stop()
	
	return

func enter() -> bool:
	
	rejump = true
	move_buffer = true
	
	if not state_machine.state_previous is StatePlayerWallSlide:
		
		audio_stream_players.wall_slide.play()
		
		if state_machine.state_previous.state != States.WALL_JUMP_UP:
			timers.land_audio_stream_pause.call_pause(audio_stream_players.land_wall.play)
		
		gpu_particles_2ds.particles_wall_side_set(gpu_particles_2ds.wall_slide)
		gpu_particles_2ds.particles_wall_side_set(gpu_particles_2ds.water_wall_slide)
		
		timers.wall_slide_particles_delay.start()
		
		timers.wall_slide_move_buffer.stop()
	
	return true

func state_change() -> bool:
	
	if player.is_on_floor():
		state_machine.transition(States.STAND_IDLE)
		return true
	
	if enter_wall_jump():
		return true
	
	if not move_buffer or not player.wall_next:
		state_machine.transition(States.FALL)
		return true
	
	return false

func process(_delta: float) -> void:
	
	if timers.wall_slide_move_buffer.is_stopped():
		
		if player.h_move == 0:
			timers.wall_slide_move_buffer.start()
	
	elif player.h_move != 0:
		timers.wall_slide_move_buffer.stop()
	
	return

func _ready() -> void:
	
	wall_slide_particles = gpu_particles_2ds.wall_slide
	timers.wall_slide_particles_delay.wait_time = WALL_SLIDE_PARTICLES_DELAY_WAIT_TIME
	
	return

func _on_player_water_entered() -> void:
	
	wall_slide_particles = gpu_particles_2ds.water_wall_slide
	timers.wall_slide_particles_delay.wait_time = WATER_WALL_SLIDE_PARTICLES_DELAY_WAIT_TIME
	
	return

func _on_player_water_exited() -> void:
	
	wall_slide_particles = gpu_particles_2ds.wall_slide
	timers.wall_slide_particles_delay.wait_time = WALL_SLIDE_PARTICLES_DELAY_WAIT_TIME
	
	return

func _on_wall_slide_move_buffer_timeout() -> void:
	
	move_buffer = false
	
	return

func _on_wall_slide_particles_delay_timeout() -> void:
	
	wall_slide_particles.emit()
	
	return
