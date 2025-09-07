extends Control

@export_node_path("Control") var menu_main_path: NodePath

var menu_back_current: Control

@onready var menu_main := get_node(menu_main_path)

func transition() -> void:
	
	visible = false
	menu_back_current.transition()
	
	process_mode = PROCESS_MODE_DISABLED
	
	return

func _on_options(menu_back: Control) -> void:
	
	process_mode = PROCESS_MODE_ALWAYS
	
	menu_back_current = menu_back
	
	visible = true
	menu_main.transition()
	
	return
