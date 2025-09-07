@tool
extends Node

@export var web_export := false : set = web_export_set

@onready var canvas_layer := $CanvasLayer

@onready var tool_web_export_v_buttons_disable: Array[Node] = [
	$CanvasLayer/TitleScreen/VButtonsContainer/QuitGame,
	$CanvasLayer/PauseMenu/Submenu/VButtonsContainer/QuitGame,
	$CanvasLayer/Options/Video/VButtonsContainer/WindowMode,
	$CanvasLayer/Options/Video/VButtonsContainer/WindowScale,
] 

@onready var tool_web_export_v_buttons_enable: Array[Node] = [
	$CanvasLayer/Options/Keyboard/Menu/VButtons/UI/VButtonsContainer/Fullscreen,
	$CanvasLayer/Options/Controller/Menu/VButtons/UI/VButtonsContainer/Fullscreen
] 

const AMBIENCE_DEFAULT_FADE_TWEEN_DURATION := 1.2

func web_export_set(value: bool) -> void:
	
	web_export = value
	
	if Engine.is_editor_hint():
		
		for v_button in tool_web_export_v_buttons_disable:
			v_button.disabled = web_export
		
		for v_button in tool_web_export_v_buttons_enable:
			v_button.disabled = not web_export
		
		return
	
	Globals.web_export = web_export
	
	return

func _ready() -> void:
	
	if Engine.is_editor_hint():
		return
	
	if not web_export:
		$CanvasLayer/InputPromptsContainer/Fullscreen.free()
	
	return

func _on_ambience_default_fade() -> void:
	
	var ambience_default_fade_tween := create_tween().set_parallel().set_trans(Tween.TRANS_CUBIC)
	
	var ambience_default_volume_db_set := func(volume_db: float): AudioServer.set_bus_volume_db(Globals.AudioBuses.AMBIENCE_DEFAULT, volume_db)
	
	ambience_default_volume_db_set.call(Globals.VOLUME_DB_MIN)
	ambience_default_fade_tween.tween_method(ambience_default_volume_db_set, AudioServer.get_bus_volume_db(Globals.AudioBuses.AMBIENCE_DEFAULT), Globals.VOLUME_DB_MAX, AMBIENCE_DEFAULT_FADE_TWEEN_DURATION)
	
	return
