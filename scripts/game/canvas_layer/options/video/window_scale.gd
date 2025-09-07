@tool
extends VButtonCenterExtendSelect

func _ready() -> void:
	
	super()
	
	if Engine.is_editor_hint():
		return
	
	if not disabled:
		Options.window_mode_changed.connect(_on_options_window_mode_changed)
	
	return

func _on_options_window_mode_changed(window_mode: DisplayServer.WindowMode) -> void:
	
	match window_mode:
		
		DisplayServer.WindowMode.WINDOW_MODE_MAXIMIZED, DisplayServer.WindowMode.WINDOW_MODE_FULLSCREEN:
			disabled = true
		
		_:
			disabled = false
	
	return
