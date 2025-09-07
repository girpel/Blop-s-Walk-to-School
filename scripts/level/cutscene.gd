extends AnimationPlayer

var reset_oneshot := false

func reset() -> void:
	
	Globals.cutscene_ended = false
	play("reset")
	
	if reset_oneshot:
		return
	
	reset_oneshot = true
	get_animation_library('').get_animation("default").remove_track(9)
	
	return
