extends "res://scripts/npcs/npc_interact.gd"

@export_multiline var dialouge_alternative: String

@onready var dialouge_initial: String = dialouge

func reset() -> void:
	
	set_physics_process(true)
	dialouge = dialouge_initial
	
	return

func text_update() -> void:
	
	if Globals.player.state_machine.state_current.state == StatePlayer.States.WALL_JUMP_UP:
		
		dialouge = dialouge_alternative
		set_physics_process(false)
	
	return

func _physics_process(_delta: float) -> void:
	
	text_update()
	
	return

func _on_player_interact(_player_screen_position_y: int, npc_dialouge: String, _npc_pitch_scale: float) -> void:
	
	set_physics_process(dialouge != npc_dialouge and is_physics_processing())
	
	return
