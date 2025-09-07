extends CanvasLayer

func _ready() -> void:
	
	custom_viewport = get_tree().root
	
	return

var oneshot := true

func _exit_tree() -> void:
	
	custom_viewport = get_viewport()
	
	return
