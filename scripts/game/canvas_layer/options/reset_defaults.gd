@tool
extends VButton

@export var v_buttons_containers_paths: Array[NodePath] = []

var v_button_center_extends: Array[VButtonCenterExtend] = []

func v_button_center_extends_set() -> void:
	
	await v_buttons_container.ready
	
	for v_buttons_container_path in v_buttons_containers_paths:
		
		for v_button in get_node(v_buttons_container_path).v_buttons:
			
			if v_button is VButtonCenterExtend:
				v_button_center_extends.append(v_button)
	
	return

func _ready() -> void:
	
	super()
	
	if Engine.is_editor_hint():
		return
	
	v_button_center_extends_set()
	button.pressed.connect(_on_button_pressed)
	
	return

func _on_button_pressed() -> void:
	
	for v_button_center_extend in v_button_center_extends:
		
		if not v_button_center_extend.disabled:
			v_button_center_extend.value_default_set_to()
	
	return
