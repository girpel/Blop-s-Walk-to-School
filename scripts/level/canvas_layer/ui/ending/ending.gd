@tool
extends ColorRect

signal fade_tween_finished(dialouge: String)

@export_multiline var dialouge: String

@export var items: Resource
@export var continue_audio_stream: AudioStream

const FADE_TWEEN_DURATION := 2

const FADE_STEP_MIN := 0
const FADE_STEP_MAX := 1

var item_index := 0

var continue_enable := false

@onready var label_dialouge := $LabelDialouge
@onready var label_item := $LabelItem
@onready var item_texture := $ItemTexture

@onready var delay := $Delay
@onready var input_prompt_continue_delay := $InputPromptContinueDelay

func reset() -> void:
	
	continue_enable = false
	Globals.ending = false
	
	var fade_reset_tween := create_tween()
	fade_reset_tween.finished.connect(set_process_mode.bind(PROCESS_MODE_DISABLED))
	
	fade_reset_tween.tween_property(self, "material:shader_parameter/fade_step", FADE_STEP_MIN, 0)
	
	label_dialouge.visible = false
	label_item.visible = false
	item_texture.texture = null
	
	return

func continue_update() -> void:
	
	if continue_enable and (Inputs.interact_just or Inputs.ui_accept_just):
		
		input_prompt_continue_delay.stop()
		
		UIAudioStreamPlayer.play_stream(continue_audio_stream)
		get_tree().call_group("game_reset", "reset")
	
	return

func _ready() -> void:
	
	material.set_shader_parameter("size", size)
	
	return

func _process(_delta: float) -> void:
	
	if Engine.is_editor_hint():
		return
	
	continue_update()
	
	return

func _on_school_door_finished() -> void:
	
	if Engine.is_editor_hint():
		return
	
	process_mode = PROCESS_MODE_ALWAYS
	
	var item: String
	
	if items.DICT.has(Globals.coins_count):
		item = items.DICT[Globals.coins_count]
	
	else:
		var items_dict_keys: Array = items.DICT.keys()
		item = items.DICT[items_dict_keys[items_dict_keys.bsearch(Globals.coins_count) - 1]]
	
	label_dialouge.text_set(item)
	label_item.text_set(item)
	
	item_texture.texture_set(item)
	
	var fade_tween := create_tween().set_parallel().set_trans(Tween.TRANS_CUBIC)
	
	fade_tween.tween_property(self, "material:shader_parameter/fade_step", FADE_STEP_MAX, FADE_TWEEN_DURATION)
	
	var ambience_default_volume_db_set := func(volume_db: float): AudioServer.set_bus_volume_db(Globals.AudioBuses.AMBIENCE_DEFAULT, volume_db)
	fade_tween.tween_method(ambience_default_volume_db_set, AudioServer.get_bus_volume_db(Globals.AudioBuses.AMBIENCE_DEFAULT), Globals.VOLUME_DB_MIN, FADE_TWEEN_DURATION)
	
	fade_tween.finished.connect(delay.start)
	
	return

func _on_delay_timeout() -> void:
	
	fade_tween_finished.emit(dialouge % [Globals.coins_count, '' if Globals.coins_count == 1 else 's'])
	
	return

func _on_item_label_finished() -> void:
	
	continue_enable = true
	
	return
