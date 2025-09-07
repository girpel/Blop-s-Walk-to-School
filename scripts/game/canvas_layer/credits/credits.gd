extends Control

signal return_reset

var reset_is := false

@onready var return_button = $VBoxContainer/Return/Button

func transition() -> void:
	
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = true
	return_button.grab_focus_skip()
	
	return

func reset():
	
	reset_is = true
	transition()
	
	return

func _on_return_pressed() -> void:
	
	if not reset_is:
		return
	
	reset_is = false
	
	return_reset.emit()
	
	return
