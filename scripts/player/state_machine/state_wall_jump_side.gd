extends StatePlayerWallJump

const JUMP_H_SPEED := 200
const WATER_JUMP_H_SPEED_MULT := 0.99

var jump_h_speed_mult := 1.0

var h_jump := true

func enter() -> bool:
	
	if not super():
		return false
	
	h_jump = true
	timers.h_jump.start()
	
	player.h_direction = -player.wall_side
	player.velocity.x = JUMP_H_SPEED * jump_h_speed_mult * player.wall_side
	
	h_direction_reset = player.h_direction
	
	return true

func state_change() -> bool:
	
	if super():
		return true
	
	if (player.velocity.x == 0 or player.h_move == sign(player.velocity.x)) and not h_jump:
		state_machine.transition(States.JUMP)
		return true
	
	return false

func _init() -> void:
	
	super()
	
	state = States.WALL_JUMP_SIDE
	
	h_deceleration_mult = 0.5
	h_accelerate = false
	
	return

func _on_player_water_entered() -> void:
	
	super()
	jump_h_speed_mult *= WATER_JUMP_H_SPEED_MULT
	
	return

func _on_player_water_exited() -> void:
	
	super()
	jump_h_speed_mult /= WATER_JUMP_H_SPEED_MULT
	
	return

func _on_h_jump_timeout() -> void:
	
	h_jump = false
	
	return
