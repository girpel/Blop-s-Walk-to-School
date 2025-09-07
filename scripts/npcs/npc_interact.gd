extends "npc.gd"

@export_multiline var dialouge
@export var pitch_scale := 1.0

func _on_area_2d_body_entered(body: Node) -> void:
	
	body._on_npc_area_2d_body_entered(self)
	
	return

func _on_area_2d_body_exited(body: Node) -> void:
	
	body._on_npc_area_2d_body_exited(self)
	
	return
