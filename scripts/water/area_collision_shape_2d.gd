@tool
extends CollisionShape2D

const POSITION_OFFSET := -2

@onready var water := get_parent()
@onready var shader_buffer := $CanvasLayer/ShaderBuffer

@onready var water_y: float = (global_position - shape.size / 2).y

func tool_shader_rect_update() -> void:
	
	var shape_size_half: Vector2 = shape.size / 2
	
	position.y = POSITION_OFFSET + shape_size_half.y
	
	shader_buffer.position = global_position - shape_size_half
	shader_buffer.size = shape.size
	
	return

func _ready() -> void:
	
	if Engine.is_editor_hint():
		return
	
	shader_buffer.size = shape.size
	
	return

func _process(_delta: float) -> void:
	
	if Engine.is_editor_hint():
		
		tool_shader_rect_update()
		
		return
	
	return

func _on_area_2d_body_entered(body: Node) -> void:
	
	if Engine.is_editor_hint():
		return
	
	body._on_water_area_2d_body_entered(water_y)
	
	return

func _on_area_2d_body_exited(body: Node) -> void:
	
	if Engine.is_editor_hint():
		return
	
	body._on_water_area_2d_body_exited(water_y)
	
	return
