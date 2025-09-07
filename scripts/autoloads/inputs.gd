extends Node

enum InputTypes {KEYBOARD, CONTROLLER}

const AXIS_DEADZONE := 0.5

var input_type = InputTypes.KEYBOARD

var fullscreen_just := false

var ui_pause_just := false
var ui_accept_just := false

var h_move := 0
var h_move_just := 0

var jump := false
var jump_just := false

var up := false

var wall_jump_up := false
var wall_jump_up_just := false

var crouch := false
var crouch_just := false

var interact := false
var interact_just := false
var interact_just_released := false

var input_disable := false
var input_disable_current := input_disable

func input_type_update(event: InputEvent) -> void:
	
	if event is InputEventKey:
		input_type = InputTypes.KEYBOARD
	
	elif event is InputEventJoypadButton or (event is InputEventJoypadMotion and abs(event.axis_value) > Inputs.AXIS_DEADZONE):
		input_type = InputTypes.CONTROLLER
	
	return

func input_update() -> void:
	
	if Globals.web_export:
		fullscreen_just = Input.is_action_just_pressed("fullscreen")
	
	if input_disable_current:
		
		ui_pause_just = false
		ui_accept_just = false
		
		h_move = 0
		h_move_just = 0
		
		jump = false
		jump_just = false
		
		wall_jump_up = false
		wall_jump_up_just = false
		
		up = false
		
		crouch = false
		
		interact = false
		interact_just = false
		interact_just_released = false
		
		return
	
	ui_pause_just = Input.is_action_just_pressed("ui_pause")
	ui_accept_just = Input.is_action_just_pressed("ui_accept")
	
	h_move = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	h_move_just = int(Input.is_action_just_pressed("move_right")) - int(Input.is_action_just_pressed("move_left"))
	
	jump = Input.is_action_pressed("jump")
	jump_just = Input.is_action_just_pressed("jump")
	
	wall_jump_up = Input.is_action_pressed("wall_jump_up")
	wall_jump_up_just = Input.is_action_just_pressed("wall_jump_up")
	
	up = Input.is_action_pressed("up")
	
	crouch = Input.is_action_pressed("crouch")
	crouch_just = Input.is_action_just_pressed("crouch")
	
	interact = Input.is_action_pressed("interact")
	interact_just = Input.is_action_just_pressed("interact")
	interact_just_released = Input.is_action_just_released("interact")
	
	return

func _ready() -> void:
	
	process_mode = PROCESS_MODE_ALWAYS
	
	return

func _input(event: InputEvent) -> void:
	
	input_type_update(event)
	
	return

func _process(_delta: float) -> void:
	
	set_deferred("input_disable_current", input_disable)
	input_update()
	
	return
