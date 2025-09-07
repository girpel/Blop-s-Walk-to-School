extends CharacterBody2D

signal h_direction_changed (h_direction: int)

signal water_entered
signal water_exited

signal surface_changed (surface_index: int)

signal interact (player_screen_position_y: int, npc_dialouge: String, npc_pitch_scale: float)

@export var input_disable := false

const H_ACCELERATION := 20
const H_DECELERATION := 28
const H_SPEED_MAX := 115

const V_DECELERATION := 24
const V_SPEED_MIN := -600
const V_SPEED_MAX := 600

const WATER_H_ACCELERATION_MULT := 0.75
const WATER_H_DECELERATION_MULT := 0.75
const WATER_H_SPEED_MAX_MULT := 0.8

const WATER_V_DECELERATION_MULT := 0.35
const WATER_V_SPEED_MIN_MULT := 0.5
const WATER_V_SPEED_MAX_MULT := 0.5

const WATER_Y_DIFFERENCE := 3

const NPC_CURRENT_DIFFERENCE_MAX := Globals.TilesSize.SOLIDS_REGULAR * 2

const SURFACE_COLLISION_LAYERS_INDEXES := {Globals.CollisionLayers.SOLIDS_REGULAR: 0, Globals.CollisionLayers.SOLIDS_ONE_WAY: 1}
const SURFACE_TILE_MAPS_INDEXES := {"Regular": 0, "OneWay": 1}

var physics_disable := false

var h_move := Inputs.h_move
var jump := Inputs.jump
var jump_just_buffer := Inputs.jump_just
var jump_just := jump_just_buffer
var wall_jump_up := Inputs.wall_jump_up
var wall_jump_up_just_buffer := Inputs.wall_jump_up
var wall_jump_up_just := wall_jump_up_just_buffer or (jump_just and Inputs.up)
var crouch := Inputs.crouch
var interact_just := Inputs.interact_just

var collision_rect := Rect2(Vector2.ZERO, Vector2.ZERO)
var collision_rect_position_offset := Vector2.ZERO

var velocity_y_last := velocity.y

var h_direction := -1 : set = h_direction_set
var h_direction_reset := 0

var h_deceleration := 1.0
var h_deceleration_mult := 1.0
var h_speed_max_mult := 1.0	
var h_accelerate := true

var v_deceleration_mult := 1.0
var v_speed_min_mult := 1.0
var v_speed_max_mult := 1.0

var wall_next := false
var wall_side := 1

var collision_mask_initial := collision_mask

var water := 0
var water_ys := []
var water_in := false

var surface_index_current := -1

var npc_current: AnimatedSprite2D

@onready var tree := get_tree()
@onready var level := get_parent()

@onready var position_clamp_rect: Rect2 = level.AREA_RECT

@onready var collision_shape_2d := $CollisionShape2D
@onready var sprite_exclamation_mark := $Sprite2D/ExclamationMark
@onready var timers := $Timers
@onready var state_machine := $StateMachine

@onready var audio_stream_players_children := $AudioStreamPlayers.get_children()

@onready var world_2d := get_world_2d()

func h_direction_set(value: int) -> void:
	
	if h_direction == value:
		return
	
	h_direction = value
	h_direction_changed.emit(h_direction)
	
	return

func mute(value: bool) -> void:
	
	var audio_stream_players_children_volume_db := Globals.VOLUME_DB_MIN if value else Globals.VOLUME_DB_MAX
	
	for audio_stream_players_child in audio_stream_players_children:
		audio_stream_players_child.volume_db = audio_stream_players_children_volume_db
	
	return

func tiles_intersect(rays_component: int, rays_side: int, rays_length: int, rays_collision_mask: int, rays_collision_area := false) -> Dictionary:

	var rays_component_other := 1 - rays_component
	var rays_component_vector := Vector2(rays_component_other, rays_component)
	var rays_component_vector_other := Vector2(rays_component, rays_component_other)
	
	var rays_position := (collision_rect.position + collision_rect.size * (1 - rays_side) / 2)[rays_component]
	var rays_position_difference: float = (collision_rect.size / ceil(collision_rect.size / Globals.TilesSize.SOLIDS_REGULAR))[rays_component_other]
	
	var ray_position := collision_rect.position[rays_component_other]
	
	while ray_position <= collision_rect.end[rays_component_other]:
		
		var ray_position_start := rays_position * rays_component_vector + ray_position * rays_component_vector_other
		
		var ray_query := PhysicsRayQueryParameters2D.create(ray_position_start, ray_position_start - rays_length * rays_side * rays_component_vector, rays_collision_mask)
		
		ray_query.hit_from_inside = true
		
		ray_query.collide_with_areas = rays_collision_area
		ray_query.collide_with_bodies = not rays_collision_area
		
		var ray_intersection := world_2d.direct_space_state.intersect_ray(ray_query)
		
		if ray_intersection and ray_intersection.normal == rays_component_vector * rays_component * rays_side:
			return ray_intersection
		
		ray_position += rays_position_difference
	
	return {}

func wall_check(rays_side: int, rays_length: int) -> bool:
	return true if tiles_intersect(0, rays_side, rays_length, Globals.CollisionLayers.SOLIDS_REGULAR) else false

func floor_check() -> bool:
	return true if tiles_intersect(1, -1, 1, Globals.CollisionLayers.SOLIDS_REGULAR) else false

func input_get() -> void:
	
	if input_disable:
		
		h_move = 0
		
		jump = false
		jump_just_buffer = false
		jump_just = false
		
		wall_jump_up = false
		wall_jump_up_just_buffer = false
		wall_jump_up_just = false
		
		crouch = false
		
		interact_just = false
		
		return
	
	h_move = Inputs.h_move
	jump = Inputs.jump
	
	if Inputs.jump_just:
		jump_just_buffer = true
		timers.jump_just_buffer.start()
	
	wall_jump_up = Inputs.wall_jump_up
	
	if Inputs.wall_jump_up_just:
		wall_jump_up_just_buffer = true
		timers.wall_jump_up_just_buffer.start()
	
	if Options.jump_hold:
		jump_just = jump
		jump_just_buffer = jump
		wall_jump_up_just = wall_jump_up
	
	else:
		jump_just = jump_just_buffer
		wall_jump_up_just = wall_jump_up_just_buffer
	
	wall_jump_up_just = wall_jump_up_just or (jump_just and Inputs.up)
	
	crouch = Inputs.crouch
	interact_just = Inputs.interact_just
	
	return

func h_direction_update() -> void:
	
	if h_direction_reset != 0:
		h_direction = h_direction_reset
	
	h_direction = -h_move if h_move != 0 else h_direction
	
	return

func npc_current_update() -> void:
	
	if tree.paused:
		return
	
	if not npc_current:
		return
	
	var npc_position_difference_x := position.x - npc_current.position.x
	
	if h_direction == sign(npc_position_difference_x) or abs(npc_position_difference_x) < NPC_CURRENT_DIFFERENCE_MAX:
		
		sprite_exclamation_mark.visible = true
		
		if interact_just:
			interact.emit(get_global_transform_with_canvas().origin.y, npc_current.dialouge, npc_current.pitch_scale)
			input_disable = true
	
	else:
		sprite_exclamation_mark.visible = false
	
	return

func audio_bus_water_bypass_effects_update() -> void:
	
	if water == 0:
		return
	
	for water_y in water_ys:
		
		if (water_y - collision_rect.position.y) < WATER_Y_DIFFERENCE:
			
			if water_in:
				return
			
			water_in = true
			
			AudioServer.set_bus_bypass_effects(Globals.AudioBuses.WATER, false)
			
			AudioServer.get_bus_effect(Globals.AudioBuses.WATER, 0).tween_in(self)
			AudioServer.get_bus_effect(Globals.AudioBuses.WATER, 1).tween_in(self)
			
			return
	
	if not water_in:
		return
	
	water_in = false
	
	AudioServer.get_bus_effect(Globals.AudioBuses.WATER, 0).tween_out(self)
	AudioServer.get_bus_effect(Globals.AudioBuses.WATER, 1).tween_out(self).finished.connect(_on_water_audio_effect_filter_tween_out_finished)
	
	return

func collision_mask_update() -> void:
	
	collision_mask = collision_mask_initial
	
	if crouch:
		collision_mask -= Globals.CollisionLayers.SOLIDS_ONE_WAY
	
	return

func velocity_update() -> void:
	
	velocity_y_last = velocity.y if velocity.y != 0 else velocity_y_last
	
	if h_move != 0 and h_accelerate:
		velocity.x = min(abs(velocity.x) + H_ACCELERATION * h_deceleration, H_SPEED_MAX * h_speed_max_mult) * h_move
	else:
		velocity.x = max(abs(velocity.x) - H_DECELERATION * h_deceleration_mult, 0) * sign(velocity.x)
	
	velocity.y = clamp(velocity.y + V_DECELERATION * v_deceleration_mult, V_SPEED_MIN * v_speed_min_mult, V_SPEED_MAX * v_speed_max_mult)
	
	return

func slide_collisions_update(delta: float) -> void:
	
	for slide_collision_index in get_slide_collision_count():
		
		var slide_collision := get_slide_collision(slide_collision_index)
		var slide_collision_collider := slide_collision.get_collider()
		
		if slide_collision_collider is RigidBody2D:
			
			slide_collision_collider.apply_impulse(-slide_collision.get_normal() * velocity.length() * delta, slide_collision.get_position() - slide_collision_collider.global_position)
			
			if slide_collision_collider is RigidBody2DCollision:
				slide_collision_collider._collision_player()
	
	return

func collision_rect_position_update() -> void:
	
	collision_rect.position = global_position + collision_shape_2d.position + collision_rect_position_offset
	
	return

func position_clamp() -> void:
	
	var collision_rect_size_half: Vector2 = (collision_rect.size / 2).ceil()
	position = position.clamp(position_clamp_rect.position + collision_rect_size_half - Vector2.ONE,  position_clamp_rect.end - collision_rect_size_half + Vector2.ONE)
	
	return

func surface_update() -> void:
	
	var surface_intersection := tiles_intersect(1, -1, Globals.TilesSize.SOLIDS_REGULAR, Globals.SOLIDS_COLLISION_MASK)
	
	if not surface_intersection:
		return
	
	if surface_intersection.collider is TileMap:
		
		if SURFACE_TILE_MAPS_INDEXES[surface_intersection.collider.name] == surface_index_current:
			return
		
		surface_index_current = SURFACE_TILE_MAPS_INDEXES[surface_intersection.collider.name]
	
	else:
		
		if SURFACE_COLLISION_LAYERS_INDEXES[surface_intersection.collider.collision_layer] == surface_index_current:
			return
		
		surface_index_current = SURFACE_COLLISION_LAYERS_INDEXES[surface_intersection.collider.collision_layer]
	
	surface_changed.emit(surface_index_current)
	
	return

func _ready() -> void:
	
	Globals.player = self
	
	return

func _process(_delta: float) -> void:
	
	input_get()
	
	h_direction_update()
	collision_shape_2d.position.x = abs(collision_shape_2d.position.x) * h_direction
	
	npc_current_update()
	
	audio_bus_water_bypass_effects_update()
	
	return

func _physics_process(delta: float) -> void:
	
	collision_mask_update()
	
	if not physics_disable:
		
		velocity_update()
		slide_collisions_update(delta)
		
		if floor_check() and not is_on_floor():
			position.y += 1
		
		move_and_slide()
		
		position.x = round(position.x)
	
	position_clamp()
	collision_rect_position_update()
	
	wall_next = wall_check(h_direction, 1)
	wall_side = h_direction if wall_next else wall_side
	
	surface_update()
	
	return

func _on_water_area_2d_body_entered(water_y: float) -> void:
	
	water += 1
	water_ys.append(water_y)
	
	if water > 1:
		return
	
	h_deceleration *= WATER_H_ACCELERATION_MULT
	h_deceleration_mult *= WATER_H_DECELERATION_MULT
	h_speed_max_mult *= WATER_H_SPEED_MAX_MULT
	
	v_deceleration_mult *= WATER_V_DECELERATION_MULT
	v_speed_min_mult *= WATER_V_SPEED_MIN_MULT
	v_speed_max_mult *= WATER_V_SPEED_MAX_MULT
	
	water_entered.emit()
	
	return

func _on_water_area_2d_body_exited(water_y) -> void:
	
	water -= 1
	water_ys.erase(water_y)
	
	if water > 0:
		return
	
	h_deceleration /= WATER_H_ACCELERATION_MULT
	h_deceleration_mult /= WATER_H_DECELERATION_MULT
	h_speed_max_mult /= WATER_H_SPEED_MAX_MULT
	
	v_deceleration_mult /= WATER_V_DECELERATION_MULT
	v_speed_min_mult /= WATER_V_SPEED_MIN_MULT
	v_speed_max_mult /= WATER_V_SPEED_MAX_MULT
	
	water_exited.emit()
	
	return

func _on_npc_area_2d_body_entered(npc: AnimatedSprite2D) -> void:
	
	npc_current = npc
	
	return

func _on_npc_area_2d_body_exited(npc: AnimatedSprite2D) -> void:
	
	if npc == npc_current:
		npc_current = null
		sprite_exclamation_mark.visible = false
	
	return

func _on_jump_just_buffer_timeout() -> void:
	
	jump_just_buffer = false
	
	return

func _on_wall_jump_up_just_buffer_timeout() -> void:
	
	wall_jump_up_just_buffer = false
	
	return

func _on_state_machine_transitioned(state: StatePlayer) -> void:
	
	h_deceleration_mult = state.h_deceleration_mult
	
	v_speed_min_mult = state.v_speed_min_mult
	v_speed_max_mult = state.v_speed_max_mult
	
	if water > 0:
		
		h_deceleration_mult *= WATER_H_DECELERATION_MULT
		
		v_speed_min_mult *= WATER_V_SPEED_MAX_MULT
		v_speed_max_mult *= WATER_V_SPEED_MAX_MULT
	
	h_direction_reset = state.h_direction_reset
	h_accelerate = state.h_accelerate
	
	collision_rect.size = collision_shape_2d.shape.size
	collision_rect_position_offset = -collision_shape_2d.shape.size / 2
	
	return

func _on_dialouge_interact_end() -> void:
	
	input_disable = false
	
	return

func _on_water_audio_effect_filter_tween_out_finished() -> void:
	
	if water_in:
		return
	
	AudioServer.set_bus_bypass_effects(Globals.AudioBuses.WATER, true)
	
	return
