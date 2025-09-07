@tool
extends Sprite2D

const TEXTURE_BASE_DIRECTORY_PATH := "res://textures/foilage"

@onready var grandparent := get_parent().get_parent()

func tool_texture_update() -> void:
	
	if not texture:
		
		var texture_path := "{0}/{1}/{2}.png".format([TEXTURE_BASE_DIRECTORY_PATH, grandparent.name.to_lower(), name])
		
		if FileAccess.file_exists(texture_path):
			texture = load(texture_path)
	
	return

func _ready() -> void:
	
	if Engine.is_editor_hint():
		
		material.get_shader_parameter("noise_texture").noise.seed = randi()
		
		return
	
	return

func _process(_delat: float) -> void:
	
	if Engine.is_editor_hint():
		
		tool_texture_update()
		
		return
	
	return
