extends Sprite2D

const SHADER_SCALE_Y_V_MAX := 1.1
const SHADER_SCALE_Y_V_CONST := 2048
const SHADER_SCALE_Y_H_MAX := 1.0
const SHADER_SCALE_Y_H_CONST := 96
const SHADER_SCALE_Y_EASE := 0.75

const SHADER_SCALE_Y_CROUCH_IN := 0.55
const SHADER_SCALE_Y_CROUCH_OUT := 1.4
const SHADER_SCALE_Y_WALL_JUMP_SIDE := 0.7

var shader_scale_y_input_previous := 0.0
var shader_scale_y := 1.0

var shader_disable := false

var animation_crouch_previous := false

@onready var position_x_initial := position.x
@onready var shader_offset_y_const := texture.get_size().y / (vframes * 2)

func material_set_shader_parameters() -> void:
	
	if shader_disable:
		return
	
	var shader_scale_y_input: float = abs(owner.velocity.y)
	
	if shader_scale_y < 1:
		shader_scale_y = ease(shader_scale_y,SHADER_SCALE_Y_EASE)
	
	elif shader_scale_y_input != 0:
		shader_scale_y = (shader_scale_y_input * SHADER_SCALE_Y_V_MAX) / (shader_scale_y_input + SHADER_SCALE_Y_V_CONST) + 1
		
	elif shader_scale_y_input_previous != 0:
		shader_scale_y = 1 / ((shader_scale_y_input_previous * SHADER_SCALE_Y_H_MAX) / (shader_scale_y_input_previous + SHADER_SCALE_Y_H_CONST) + 1)
	
	else:
		shader_scale_y = 1 / ease(1 / shader_scale_y, SHADER_SCALE_Y_EASE)
	
	shader_scale_y_input_previous = shader_scale_y_input
	
	var shader_scale_x := 1 / shader_scale_y
	
	material.set_shader_parameter("scale", Vector2(shader_scale_x, shader_scale_y))
	material.set_shader_parameter("offset", Vector2((1 - shader_scale_x) * owner.collision_shape_2d.position.x, ceil((1 - shader_scale_y) * (shader_offset_y_const - owner.collision_shape_2d.position.y))))
	
	return

func _process(_delta: float) -> void:
	
	position.x = -position_x_initial * owner.h_direction
	offset.x = abs(offset.x) * owner.h_direction
	
	return

func _physics_process(_delta: float) -> void:
	
	material_set_shader_parameters()
	
	return

func _on_state_machine_transitioned(state: State) -> void:
	
	var shader_scale_y_mult := 1.0
	var animation_crouch_current := false
	
	shader_disable = false
	
	match state.state:
		
		StatePlayer.States.CROUCH_IDLE, StatePlayer.States.CROUCH_MOVE:
			
			animation_crouch_current = true
			
			if not animation_crouch_previous:
				material_set_shader_parameters()
				shader_scale_y_mult = SHADER_SCALE_Y_CROUCH_IN
		
		StatePlayer.States.STAND_IDLE, StatePlayer.States.STAND_MOVE:
			
			if animation_crouch_previous:
				shader_scale_y_mult = SHADER_SCALE_Y_CROUCH_OUT
		
		StatePlayer.States.WALL_SLIDE_UP, StatePlayer.States.WALL_SLIDE_DOWN:
			
			shader_disable = true
			
			material.set_shader_parameter("scale", Vector2.ONE)
			material.set_shader_parameter("offset", Vector2.ZERO)
		
		StatePlayer.States.WALL_JUMP_SIDE:
			shader_scale_y_mult = SHADER_SCALE_Y_WALL_JUMP_SIDE
	
	shader_scale_y *= shader_scale_y_mult
	animation_crouch_previous = animation_crouch_current

func _on_player_h_direction_changed(h_direction: int) -> void:
	
	flip_h = bool((h_direction + 1) / 2.0)
	
	return
