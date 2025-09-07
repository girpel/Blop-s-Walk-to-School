extends "../menu.gd"

@export_node_path("VBoxContainer") var submenu_path: NodePath
@export var stream_pause: AudioStream

@onready var submenu := get_node(submenu_path)

func transition() -> void:
	
	super()
	submenu.transition()
	
	return

func pause(value: bool) -> void:
	
	visible = value
	Inputs.input_disable = value
	
	Globals.player.physics_disable = value
	
	if Globals.cutscene_ended:
		return
	
	Globals.player.mute(value)
	
	return

func pause_update() -> void:
	
	if visible or Globals.ending:
		return
	
	if Inputs.ui_pause_just:
		
		pause(true)
		transition()
		
		UIAudioStreamPlayer.play_stream(stream_pause)
	
	return

func _process(_delta: float) -> void:
	
	pause_update()
	
	return

func _on_continue_pressed() -> void:
	
	pause(false)
	
	return

func _on_title_screen_pressed() -> void:
	
	visible = false
	Globals.player.mute(false)
	
	return
