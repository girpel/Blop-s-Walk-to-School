@tool
extends "rope.gd"

const BODY_CURRENT_VELOCITY_SPRITE_MULT := 0.2
const SPRITE_2D_ROTATION_ANGLE_OFFSET := PI / 2

@onready var sprite_2d := $Sprite2D
@onready var sprite_2d_collision_shape_2d := $Sprite2D/Area2D/CollisionShape2D
@onready var sprite_2d_collision := $Sprite2D/Collision

func tool_sprite_update() -> void:
	
	sprite_2d.position = line_2d.get_point_position(line_2d.get_point_count() - 1)
	
	var sprite_2d_texture_size: Vector2 = sprite_2d.texture.get_size() if sprite_2d.texture else Vector2.ZERO
	
	sprite_2d_collision_shape_2d.shape.size = sprite_2d_texture_size
	sprite_2d_collision_shape_2d.position = sprite_2d.offset
	sprite_2d_collision.position = sprite_2d.offset
	
	return

func sprite_update() -> void:
	
	sprite_2d.position = line_2d.points[-1]
	sprite_2d.rotation = line_2d.points[-1].angle_to_point(line_2d.points[-2]) + SPRITE_2D_ROTATION_ANGLE_OFFSET
	
	return

func points_set() -> void:
	
	super()
	
	var sprite_area_2d := $Sprite2D/Area2D
	
	sprite_area_2d.body_entered.connect(_on_sprite_area_2d_body_entered.bind(points_size - 1))
	sprite_area_2d.body_exited.connect(_on_sprite_area_2d_body_exited.bind(points_size - 1))
	
	return

func _process(delta: float) -> void:
	
	super(delta)
	
	if Engine.is_editor_hint():
		
		tool_sprite_update()
		
		return
	
	sprite_update()
	
	return

func _on_sprite_area_2d_body_entered(body: Node, line_index: int) -> void:
	
	super._on_line_area_2d_body_entered(body, line_index)
	
	if Engine.is_editor_hint():
		return
	
	body_current_velocity_mult *= BODY_CURRENT_VELOCITY_SPRITE_MULT
	sprite_2d_collision.play_delay()
	
	return

func _on_sprite_area_2d_body_exited(body: Node, line_index: int) -> void:
	
	super._on_line_area_2d_body_exited(body, line_index)
	
	if Engine.is_editor_hint():
		return
	
	body_current_velocity_mult /= BODY_CURRENT_VELOCITY_SPRITE_MULT
	
	return
