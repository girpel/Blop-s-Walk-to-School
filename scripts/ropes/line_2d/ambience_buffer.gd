extends Timer

@export var wait_time_min := 0.1
@export var wait_time_max := 6.0

func _on_timeout() -> void:
	
	wait_time = randf_range(wait_time_min, wait_time_max)
	
	return
