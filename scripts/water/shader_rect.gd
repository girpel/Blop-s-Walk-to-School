@tool
extends ColorRect

func _init() -> void:
	
	if Engine.is_editor_hint():
		
		material.get_shader_parameter("noise_texture").noise.seed = randi()
		
		return
	
	return

func _ready() -> void:
	
	if Engine.is_editor_hint():
		return
	
	Options.water_shader_visiblilty_changed.connect(set_visible)
	
	return

func _process(_delta: float) -> void:
	
	if Engine.is_editor_hint():
		
		material.set_shader_parameter("size", size)
		
		return
	
	return
