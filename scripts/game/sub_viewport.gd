extends SubViewport

const SIZE := Vector2i(1920, 1080)
const SIZE_PADDING := 256 * Vector2i.ONE

func _ready() -> void:
	
	size = SIZE + SIZE_PADDING
	
	return
