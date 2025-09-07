extends "../menu.gd"

signal entered
signal reentered

signal start_started
signal start_finished

signal cutscene_reset
signal cutscene_play

signal credits

@export_node_path("VButtonsContainer") var v_buttons_container_path: NodePath

var start_pressed := false

@onready var animation_player := $AnimationPlayer
@onready var v_buttons_container := get_node(v_buttons_container_path)

@onready var player_camera_2d := Globals.player.get_node("Camera2D")
@onready var player_camera_2d_position_initial: Vector2 = player_camera_2d.global_position

func transition() -> void:
	
	super()
	v_buttons_container.focus()
	
	return

func v_buttons_container_disable(disabled: bool) -> void:
	
	for v_button in v_buttons_container.v_buttons:
		v_button.button.disabled = disabled
	
	return

func _ready() -> void:
	
	v_buttons_container.focus()
	
	return

func _on_reenter() -> void:
	
	process_mode = PROCESS_MODE_ALWAYS
	visible = true
	
	start_pressed = false
	
	v_buttons_container_disable(false)
	
	if Globals.cutscene_ended:
		player_camera_2d.global_position = player_camera_2d_position_initial
		get_viewport().get_camera_2d().reset_smoothing.call_deferred()
	
	else:
		cutscene_reset.emit()
	
	entered.emit()
	reentered.emit()
	
	v_buttons_container.focus()
	animation_player.play()
	
	return

func _on_start_pressed() -> void:
	
	start_pressed = true
	start_started.emit()
	
	v_buttons_container_disable(true)
	
	Inputs.input_disable = false
	Globals.player.physics_disable = false
	
	player_camera_2d.position = Vector2.ZERO
	
	return

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	
	if not start_pressed:
		return
	
	start_finished.emit()
	
	if not Globals.cutscene_ended:
		cutscene_play.emit()
	
	visible = false
	process_mode = PROCESS_MODE_DISABLED
	
	return

func _on_credits_pressed() -> void:
	
	process_mode = PROCESS_MODE_DISABLED
	credits.emit()
	
	return
