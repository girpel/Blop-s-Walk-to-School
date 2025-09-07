@tool
extends TextureRect

@onready var texture_inital := texture
@onready var sub_viewport := owner.get_node(texture.viewport_path)

func _ready() -> void:
	
	if Engine.is_editor_hint():
		
		sub_viewport.size = size
		sub_viewport.get_node("Camera2D").position = position
		
		return
	
	return

func _on_fish_door_tree_paused() -> void:
	
	texture = ImageTexture.create_from_image(texture.get_image())
	
	return

func _on_fish_door_tree_continued() -> void:
	
	texture = texture_inital
	
	return
