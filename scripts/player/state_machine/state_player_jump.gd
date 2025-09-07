extends StatePlayerAir

class_name StatePlayerJump

const JUMP_V_SPEED := 320
const WATER_JUMP_V_SPEED_MULT := 0.75

var jump_v_speed_mult := 1.0

var v_jump := true
var jump_oneshot := false

func enter() -> bool:
	
	player.jump_just_buffer = false
	
	v_jump = true
	
	if state_machine.state_previous.rejump:
		
		jump_oneshot = true
		audio_stream_players.jump.play()
	
	return true

func state_change() -> bool:
	
	if player.velocity.y >= 0:
		state_machine.transition(States.FALL)
		return true
	
	return super()

func physics_process(delta: float) -> void:
	
	if v_jump:
		
		if player.jump or jump_oneshot or Options.jump_uniform:
			jump_oneshot = false
			player.velocity.y = -JUMP_V_SPEED * jump_v_speed_mult
		
		else:
			v_jump = false
	
	return super(delta)

func _init() -> void:
	
	super()
	rejump = false
	
	return

func _on_v_jump_timeout() -> void:
	
	v_jump = false
	
	return

func _on_player_water_entered() -> void:
	
	jump_v_speed_mult *= WATER_JUMP_V_SPEED_MULT
	
	return

func _on_player_water_exited() -> void:
	
	jump_v_speed_mult /= WATER_JUMP_V_SPEED_MULT
	
	return
