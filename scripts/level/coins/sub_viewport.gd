extends SubViewport

func _ready() -> void:
	
	size = Globals.VIEWPORT_SIZE + Vector2(get_parent().get_viewport().SIZE_PADDING)
	world_2d = Globals.player.world_2d
	
	return
