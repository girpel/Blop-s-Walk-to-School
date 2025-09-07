extends Control

signal options (menu_back: Control)

@onready var tree := get_tree()

func transition() -> void:
	
	process_mode = PROCESS_MODE_ALWAYS
	
	return

func _on_options_pressed() -> void:
	
	process_mode = PROCESS_MODE_DISABLED
	options.emit(self)
	
	return

func _on_quit_game_pressed() -> void:
	
	tree.quit()
	
	return
