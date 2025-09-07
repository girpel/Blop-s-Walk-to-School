extends AnimatedSprite2D

signal finished

const BODY_CRRENT_POSITION_X_DISTANCE_MIN := 4
const BODY_CURRENT_TWEEN_VELOCTIY := 48

var body_current: Node2D
var body_current_wait := false

@onready var animation_player := $AnimationPlayer

func body_current_update() -> void:
	
	if not body_current:
		return
	
	if not body_current.interact_just:
		return
	
	Globals.ending = true
	
	body_current.input_disable = true
	body_current.sprite_exclamation_mark.visible = false
	
	body_current_wait = true
	
	return

func body_current_wait_update() -> void:
	
	if not body_current_wait:
		return
	
	if not body_current.state_machine.state_current is StatePlayerGround:
		return
	
	body_current_wait = false
	
	var body_current_position_x_difference := (body_current.position - position).x
	var body_current_position_x_distance: float = abs(body_current_position_x_difference)
	
	if body_current_position_x_distance < BODY_CRRENT_POSITION_X_DISTANCE_MIN:
		
		animation_player.play("default")
		
		return
	
	var body_current_sprite_2d := body_current.get_node("Sprite2D")
	
	body_current_sprite_2d.flip_h = body_current_position_x_difference > 0
	body_current_sprite_2d.get_node("AnimationTree").active = false
	body_current_sprite_2d.get_node("AnimationPlayer").play("stand_move")
	
	var body_current_tween := create_tween().set_trans(Tween.TRANS_CUBIC)
	
	body_current_tween.tween_property(body_current, "position:x", position.x, body_current_position_x_distance / BODY_CURRENT_TWEEN_VELOCTIY)
	body_current_tween.finished.connect(animation_player.play.bind("default"))
	
	return

func _process(_delta: float) -> void:
	
	body_current_update()
	body_current_wait_update()
	
	return

func _on_area_2d_body_entered(body: Node2D) -> void:
	
	if body_current_wait:
		return
	
	body.sprite_exclamation_mark.visible = true
	body_current = body
	
	return

func _on_area_2d_body_exited(body: Node2D) -> void:
	
	if body_current_wait:
		return
	
	body.sprite_exclamation_mark.visible = false
	body_current = null
	
	return

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	
	finished.emit()
	
	return
