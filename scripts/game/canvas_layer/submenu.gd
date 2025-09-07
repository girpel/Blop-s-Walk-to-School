extends VBoxContainer

const TRANSITION_TWEEN_SCALE_STEP := 0.016
const TRANSITION_TWEEN_DURATION := 0.18

@export_node_path("VButtonsContainer") var v_buttons_container_0_path: NodePath

@onready var v_buttons_container_0 := get_node(v_buttons_container_0_path)
@onready var center := position + size / 2

func scale_centered_set(scale_component: float) -> void:
	
	scale = snapped(scale_component, TRANSITION_TWEEN_SCALE_STEP) * Vector2.ONE
	position = center - size * scale / 2
	
	return

func transition() -> void:
	
	visible = true
	create_tween().tween_method(scale_centered_set, 0.0, 1.0, TRANSITION_TWEEN_DURATION).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	
	v_buttons_container_0.focus()
	
	return
