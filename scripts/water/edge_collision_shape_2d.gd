@tool
extends CollisionShape2D

@export var springs_size := 0
@export var springs_difference := 0

@export var points: Array[Vector2] = []

const COLOR := Color.WHITE
const WIDTH := 1

const SPRING_TENSION := 0.1
const SPRING_DAMP := 0.2
const SPRING_SPREAD := 0.015
const SPRINGS_UPDATE_ITERATIONS := 8

const BODY_CURRENT_SPEED_MULT := 0.7

var curve_2d := Curve2D.new()

var springs: Array[Spring] = []
var springs_difference_left: Array[float] = []
var springs_difference_right: Array[float] = []

var body_current: CharacterBody2D
var body_current_floor := false

var bubbles_wait := false

@onready var bubbles := $Bubbles
@onready var bubbles_delay := $BubblesDelay
@onready var light_occluder_2D := $LightOccluder2D

class Spring:
	
	var position_initial: Vector2
	var position_current: Vector2
	
	var speed := 0.0
	
	func _init(_position_initial: Vector2):
		
		position_initial = _position_initial
		position_current = position_initial
		
		return

func tool_shape_update() -> void:
	
	shape.a = Vector2.ZERO
	shape.b = max(shape.a.x + 1, shape.b.x) * Vector2.RIGHT
	
	var line_size_x: float = (shape.b - shape.a).x
	
	springs_size = ceil(line_size_x / Globals.TilesSize.SOLIDS_REGULAR)
	springs_difference = round(line_size_x / springs_size)
	
	shape.b.x = springs_difference * springs_size
	
	points.clear()
	
	for point_x in range(shape.a.x, shape.b.x + 1, springs_difference):
		points.append(Vector2(point_x, shape.a.y))
	
	light_occluder_2D.occluder.polygon[0] = shape.a 
	light_occluder_2D.occluder.polygon[1] = shape.b
	
	return

func tool_line_draw() -> void:
	
	draw_line(shape.a, shape.b, COLOR, WIDTH)
	
	return

func springs_set() -> void:
	
	springs_size += 1
	
	springs_difference_left.resize(springs_size)
	springs_difference_right.resize(springs_size)
	
	for point in points:
		springs.append(Spring.new(point))
		curve_2d.add_point(point)
	
	return

func springs_update(delta: float) -> void:
	
	if body_current:
		
		if not body_current_floor:
			
			var body_current_position_x: float = (body_current.collision_rect.position + body_current.collision_rect.size / 2 - global_position).x
			
			springs[clamp(round(body_current_position_x / springs_difference), 0, springs_size - 1)].speed += body_current.velocity_y_last * BODY_CURRENT_SPEED_MULT * delta
			
			if not bubbles_wait:
				
				bubbles_wait = true
				bubbles_delay.start()
				
				bubbles.position.x = body_current_position_x
				bubbles.emit()
		
		body_current_floor = body_current.is_on_floor()
	
	for spring in springs:
		spring.position_current.y += spring.speed
		spring.speed += SPRING_TENSION * (spring.position_initial - spring.position_current).y - SPRING_DAMP * spring.speed
	
	for iteration in SPRINGS_UPDATE_ITERATIONS:
		
		for spring_index in springs_size:
			
			if spring_index != 0:
				springs_difference_left[spring_index] = SPRING_SPREAD * (springs[spring_index].position_current.y - springs[spring_index - 1].position_current.y)
				springs[spring_index - 1].speed += springs_difference_left[spring_index]
			
			if spring_index != springs_size - 1:
				springs_difference_right[spring_index] = SPRING_SPREAD * (springs[spring_index].position_current.y - springs[spring_index + 1].position_current.y)
				springs[spring_index + 1].speed += springs_difference_right[spring_index]
		
		for spring_index in springs_size:
			
			if spring_index != 0:
				springs[spring_index - 1].position_current.y += springs_difference_left[spring_index]
			if spring_index != springs_size - 1:
				springs[spring_index + 1].position_current.y += springs_difference_right[spring_index]
	
	for spring_index in springs_size:
		curve_2d.set_point_position(spring_index, springs[spring_index].position_current)
	
	queue_redraw()
	
	return

func curve_2d_draw() -> void:
	
	draw_polyline(curve_2d.get_baked_points(), COLOR, WIDTH)
	
	return

func _ready() -> void:
	
	if Engine.is_editor_hint():
		return
	
	springs_set()
	
	return

func _process(_delta: float) -> void:
	
	if Engine.is_editor_hint():
		
		tool_shape_update()
		
		return
	
	return

func _physics_process(delta: float) -> void:
	
	if Engine.is_editor_hint():
		return
	
	springs_update(delta)
	
	return

func _draw() -> void:
	
	if Engine.is_editor_hint():
		
		tool_line_draw()
		
		return
	
	curve_2d_draw()
	
	return

func _on_edge_body_entered(body: Node) -> void:
	
	if Engine.is_editor_hint():
		return
	
	if not body_current:
		body_current = body
		body_current_floor = false
	
	return

func _on_edge_body_exited(body: Node) -> void:
	
	if Engine.is_editor_hint():
		return
	
	if body == body_current:
		body_current = null
	
	return

func _on_bubbles_delay_timeout() -> void:
	
	bubbles_wait = false
	
	return
