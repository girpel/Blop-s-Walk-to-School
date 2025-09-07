extends Button

const CHANGE_TWEEM_OFFSET := 3
const CHANGE_TWEEN_DURATION := 0.08

var position_x_initial: float

func position_x_initial_set() -> void:
	
	position_x_initial = position.x
	
	return

func change_tween(offset_mult: int) -> void:
	
	position.x = position_x_initial + CHANGE_TWEEM_OFFSET * offset_mult
	create_tween().tween_property(self, "position:x", position_x_initial, CHANGE_TWEEN_DURATION)
	
	return

func _on_visibility_changed() -> void:
	
	position_x_initial_set.call_deferred()
	
	return
