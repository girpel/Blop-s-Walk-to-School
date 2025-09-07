extends StatePlayerWallSlide

const JUMP_V_SPEED := 300
const WATER_JUMP_V_SPEED_MULT := 0.75

const WALL_JUMP_UP_TRANSITION_VELOCITY_Y := -130

var jump_v_speed_mult := 1.0

var v_jump := true
var player_jump: Callable

func enter() -> bool:
	
	if enter_wall_jump():
		timers.land_audio_stream_pause.call_pause(audio_stream_players.land_wall.play)
		return false
	
	if player.velocity.y > 0:
		state_machine.transition(States.WALL_SLIDE_DOWN)
		return false
	
	if not super(): 
		return false
	
	v_jump = not timers.v_jump.is_stopped()
	player_jump = (func() -> bool: return player.wall_jump_up or player.jump) if state_machine.state_previous.state == States.WALL_JUMP_UP else (func() -> bool: return player.jump)
	
	return true

func state_change() -> bool:
	
	if state_machine.state_previous.state == States.WALL_JUMP_UP and player.h_move == player.wall_side and v_jump:
		
		exit_wall_slide()
		
		rejump = false
		state_machine.transition(States.WALL_JUMP_SIDE)
		
		return true
	
	wall_jump_up_transition = not Options.jump_hold or player.velocity.y > WALL_JUMP_UP_TRANSITION_VELOCITY_Y
	
	if super():
		exit_wall_slide()
		return true
	
	if player.velocity.y > 0:
		state_machine.transition(States.WALL_SLIDE_DOWN)
		return true
	
	return false

func physics_process(_delta: float) -> void:
	
	if state_change():
		return
	
	if v_jump:
		
		if player_jump.call() or Options.jump_uniform:
			player.velocity.y = -JUMP_V_SPEED * jump_v_speed_mult
		
		else:
			v_jump = false
	
	return

func exit() -> void:
	
	v_jump = false
	
	return

func _init() -> void:
	
	state = States.WALL_SLIDE_UP
	v_speed_min_mult = 0.8
	
	return

func _on_player_water_entered() -> void:
	
	super()
	jump_v_speed_mult *= WATER_JUMP_V_SPEED_MULT
	
	return

func _on_player_water_exited() -> void:
	
	super()
	jump_v_speed_mult /= WATER_JUMP_V_SPEED_MULT
	
	return

func _on_v_jump_timeout() -> void:
	
	v_jump = false
	
	return
