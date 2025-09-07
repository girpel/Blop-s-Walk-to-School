extends AudioStreamPlayer2D

const VOLUME_DB_TWEEN_DURATION := 0.24

var volume_db_initial := volume_db

@onready var tree := get_tree()
@onready var animation_player := $AnimationPlayer

func _on_science_ball_transport() -> void:
	
	play()
	create_tween().tween_property(self, "volume_db", 0, VOLUME_DB_TWEEN_DURATION)
	
	animation_player.play("science_tube")
	
	return

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	
	await create_tween().tween_property(self, "volume_db", volume_db_initial, VOLUME_DB_TWEEN_DURATION).finished
	stop()
	
	return
