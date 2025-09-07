extends AnimatedSprite2D

const TIMER_MIN := 8
const TIMER_MAX := 15

@onready var timer := $Timer

func _on_timer_timeout() -> void:
	
	play()
	timer.start(randf_range(TIMER_MIN, TIMER_MAX))
	
	return
