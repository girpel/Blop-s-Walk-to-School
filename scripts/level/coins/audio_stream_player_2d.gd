extends AudioStreamPlayer

const PLAY_TIMER_MAX := 0.07

var play_timer := 0.0

func _process(delta: float) -> void:
	
	play_timer = min(play_timer + delta, PLAY_TIMER_MAX)
	
	return

func _on_tile_map_collected() -> void:
	
	if play_timer != PLAY_TIMER_MAX:
		return
	
	play()
	play_timer = 0
	
	return
