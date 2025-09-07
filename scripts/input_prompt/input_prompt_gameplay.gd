@tool
extends "input_prompt_ui.gd"

@onready var input_prompts_container := get_parent()

func _process(delta: float) -> void:
	
	super(delta)
	
	if Engine.is_editor_hint():
		return
	
	if visible and Input.is_action_just_pressed(action) and not Inputs.input_disable:
		input_prompts_container._on_exit(input_prompts_container.position_x_tween_in_duration)
	
	return
