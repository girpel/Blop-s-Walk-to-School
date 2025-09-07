extends "button.gd"

const PRESSED_TWEEN_VALUE := -1
var PRESSED_TWEEN_DURATION := 0.04

func pressed_tween(final_val: int) -> void:
	
	create_tween().tween_property(self, focus_tween_property, final_val, PRESSED_TWEEN_DURATION)
	
	return

func _on_button_down() -> void:
	
	pressed_tween(PRESSED_TWEEN_VALUE)
	
	return

func _on_button_up() -> void:
	
	pressed_tween(focus_tween_value)
	
	return
