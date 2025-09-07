extends "../submenu.gd"

@export_node_path("Control") var menu_back_path: NodePath

@onready var menu_back := get_node(menu_back_path)

func _on_button_pressed() -> void:
	
	menu_back.visible = false
	transition()
	
	return

func _on_back_pressed() -> void:
	
	visible = false
	menu_back.transition()
	
	return
