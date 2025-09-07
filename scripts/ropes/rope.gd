@tool
extends Node2D

@export var wind := true
@export var points_difference: int = Globals.TilesSize.SOLIDS_REGULAR

@export var points_size := 0

const V_DECELERATION := 24
const POINTS_UPDATE_ITERATIONS := 16

const WIND_MULT := 0.7

var points: Array[Point] = []
var points_difference_half := points_difference / 2.0

var lines: Array[Line] = []
var lines_area_2d_collision_shape_2d: Array[CollisionShape2D] = []

var wind_noise := FastNoiseLite.new()
var wind_noise_type := FastNoiseLite.TYPE_SIMPLEX

var body_current_velocity_mult := 0.25

var body_current: CharacterBody2D
var line_index_current := 0

@onready var line_2d := $Line2D
@onready var line_collision_shape_2d := $Line2D/Area2D/CollisionShape2D
@onready var line_2d_collision := $Line2D/Collision
@onready var line_2d_collision_ambience_buffer := $Line2D/Collision/AmbienceBuffer

class Point:
	
	var position_current: Vector2
	var position_previous: Vector2
	
	func _init(_position_current: Vector2):
		
		position_current = _position_current
		position_previous = position_current
		
		return

class Line:
	
	var a: Point
	var b: Point
	
	func center() -> Vector2:
		return (a.position_current + b.position_current) / 2
	
	func _init(_a: Point, _b: Point):
		
		a = _a
		b = _b
		
		return

func tool_line_update() -> void:
	
	line_collision_shape_2d.shape.a = Vector2.ZERO
	line_collision_shape_2d.shape.b = max(line_collision_shape_2d.shape.a.y + 1, line_collision_shape_2d.shape.b.y) * Vector2.DOWN
	
	var line_size_y: float = (line_collision_shape_2d.shape.b - line_collision_shape_2d.shape.a).y
	points_size = ceil(line_size_y / points_difference)
	
	line_collision_shape_2d.shape.b.y = points_size * points_difference
	
	line_2d.clear_points()
	for point_y in range(0, line_size_y + 1, points_difference):
		line_2d.add_point(Vector2(0, point_y))
	
	return

func points_set() -> void:
	
	for point_index in points_size + 1:
		points.append(Point.new(line_2d.get_point_position(point_index)))
	
	var line_area_2d := $Line2D/Area2D
	
	for point_index in points_size:
		
		var line_area_2d_duplicate := line_area_2d.duplicate()
		
		line_area_2d_duplicate.name = line_area_2d.name + str(point_index)
		line_area_2d_duplicate.body_entered.connect(_on_line_area_2d_body_entered.bind(point_index))
		line_area_2d_duplicate.body_exited.connect(_on_line_area_2d_body_exited.bind(point_index))
		
		var line_area_2d_duplicate_collision_shape_2d := line_area_2d_duplicate.get_node("CollisionShape2D")
		
		line_area_2d_duplicate_collision_shape_2d.shape = SegmentShape2D.new()
		line_area_2d_duplicate_collision_shape_2d.shape.a = points[point_index].position_current
		line_area_2d_duplicate_collision_shape_2d.shape.b = points[point_index + 1].position_current
		
		lines_area_2d_collision_shape_2d.append(line_area_2d_duplicate_collision_shape_2d)
		add_child(line_area_2d_duplicate)
		
		lines.append(Line.new(points[point_index], points[point_index + 1]))
	
	points.remove_at(0)
	line_area_2d.queue_free()
	
	return

func points_update(delta: float) -> void:
	
	if body_current:
		
		var point_index = line_index_current + (0 if body_current.position.distance_to(lines[line_index_current].a.position_current) < body_current.position.distance_to(lines[line_index_current].b.position_current) else 1) - 1
		
		if point_index > 0:
			points[point_index].position_current += body_current.velocity * body_current_velocity_mult * delta
	
	for point_index in points_size:
		
		var point_position_current = points[point_index].position_current
		
		points[point_index].position_current += point_position_current - points[point_index].position_previous
		
		points[point_index].position_current.x += wind_noise.get_noise_2d(Time.get_ticks_msec(), point_index) * WIND_MULT * delta if wind else 0.0
		points[point_index].position_current.y += V_DECELERATION * delta
		
		points[point_index].position_previous = point_position_current
	
	for iteration in POINTS_UPDATE_ITERATIONS:
		
		var line_front := true
		
		for line in lines:
			
			var line_center = line.center()
			var line_direction = (line.b.position_current - line.a.position_current).normalized()
			
			var point_position_offset: Vector2 = line_direction * points_difference_half
			
			line.b.position_current = line_center + point_position_offset
			
			if line_front:
				line_front = false
				continue
			
			line.a.position_current = line_center - point_position_offset
	
	for point_index in points_size:
		
		line_2d.set_point_position(point_index + 1, points[point_index].position_current)
		
		lines_area_2d_collision_shape_2d[point_index].shape.a = lines[point_index].a.position_current
		lines_area_2d_collision_shape_2d[point_index].shape.b = lines[point_index].b.position_current
	
	return

func _init() -> void:
	
	wind_noise.noise_type = wind_noise_type
	
	return

func _ready() -> void:
	
	if Engine.is_editor_hint():
		return
	
	points_set()
	
	return

func _process(delta: float) -> void:
	
	if Engine.is_editor_hint():
		
		tool_line_update()
		
		return
	
	points_update(delta)
	
	return

func _on_line_area_2d_body_entered(body: Node, line_index: int) -> void:
	
	if Engine.is_editor_hint():
		return
	
	if not body_current:
		line_2d_collision.position = lines[line_index_current].center()
		line_2d_collision.play_delay()
	
	body_current = body
	line_index_current = line_index
	
	if wind:
		line_2d_collision_ambience_buffer.stop()
	
	return

func _on_line_area_2d_body_exited(_body: Node, line_index: int) -> void:
	
	if Engine.is_editor_hint():
		return
	
	if line_index_current != line_index:
		return
	
	body_current = null
	
	if wind:
		line_2d_collision_ambience_buffer.start()
	
	return

func _on_ambience_buffer_timeout() -> void:
	
	if body_current:
		return
	
	line_2d_collision.position = lines[randi_range(0, lines.size() - 1)].center()
	line_2d_collision.play_wrapper()
	
	return
