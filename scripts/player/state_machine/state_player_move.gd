extends StatePlayerGround

class_name StatePlayerMove

func state_change() -> bool:
	
	if player.wall_next:
		
		if player.wall_jump_up_just:
			state_machine.transition(States.WALL_JUMP_UP)
			return true
	
	return super()

func _on_player_water_entered() -> void:
	
	super()
	timers.water_move_particles_delay.start()
 	
	return

func _on_player_water_exited() -> void:
	
	super()
	timers.water_move_particles_delay.stop()
	
	return

func _on_water_move_particles_delay_timeout() -> void:
	
	if state_machine.state_current == self and not player.wall_next:
		gpu_particles_2ds.water_move.emit()
	
	return
