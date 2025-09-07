extends Panel

signal dialouge_audio_stream_set_pitch_scale(pitch_scale: float)

var viewport_size_y_half: float

@onready var dialouge := $Dialouge

@onready var position_y_bottom := position.y
@onready var position_y_top := (Globals.VIEWPORT_SIZE - (position + size)).y

func viewport_size_y_half_set() -> void:
	
	var viewport := get_viewport()
	await viewport.ready
	
	viewport_size_y_half = viewport.size.y / 2
	
	return

func _ready() -> void:
	
	viewport_size_y_half_set()
	
	return

func _visible_set() -> void:
	
	visible = not visible
	dialouge.process_mode = PROCESS_MODE_INHERIT if visible else PROCESS_MODE_DISABLED
	
	return

func _on_player_interact(player_screen_position_y: int, npc_dialouge: String, npc_pitch_scale: float) -> void:
	
	position.y = position_y_top if player_screen_position_y > viewport_size_y_half else position_y_bottom
	
	_visible_set()
	dialouge.text_array = npc_dialouge.split('\n')
	
	dialouge_audio_stream_set_pitch_scale.emit(npc_pitch_scale)
	
	return

func _on_ending_fade_tween_finished(ending_dialouge: String) -> void:
	
	_on_player_interact(0, ending_dialouge, Globals.FRIEND_PITCH_SCALE)
	
	return

func _on_pause_menu_hidden() -> void:
	
	if visible:
		dialouge.process_mode = PROCESS_MODE_INHERIT
	
	return

func _on_title_screen_reentered() -> void:
	
	if visible:
		dialouge.interact_end.emit()
	
	return
