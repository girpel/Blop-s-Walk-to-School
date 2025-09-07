extends Timer

class_name TimerPause

func call_pause(callable: Callable) -> void:
	
	if not is_stopped():
		return
	
	start()
	callable.call()
	
	return
