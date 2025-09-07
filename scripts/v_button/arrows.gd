extends Control

const FOCUS_TWEEN_OFFSET := 6
const FOCUS_TWEEN_DURATION := 0.15

func focus_tween(offset_mult: int, skip: bool):
	
	if skip:
		return
	
	position.y = FOCUS_TWEEN_OFFSET * offset_mult
	create_tween().tween_property(self, "position:y", 0, FOCUS_TWEEN_DURATION)
	
	return
