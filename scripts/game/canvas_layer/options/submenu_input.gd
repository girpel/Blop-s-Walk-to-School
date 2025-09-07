extends "submenu.gd"

@onready var menu_input := get_parent()

func transition() -> void:
	
	menu_input.v_scroll_bar.value = menu_input.v_scroll_bar.min_value
	menu_input.visible = true
	
	return super()

func _on_back_pressed() -> void:
	
	menu_input.visible = false
	
	return super()
