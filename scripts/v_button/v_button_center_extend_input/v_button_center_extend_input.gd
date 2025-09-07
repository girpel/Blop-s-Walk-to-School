@tool
extends VButtonCenterExtend

@export var action: StringName

var value_default_class_name := ""

@onready var input_texture_rect := $Button/HBoxContainer/HBoxContainer/InputTexture/TextureRect

func value_default_set() -> void:
	
	for event in InputMap.action_get_events(action):
		
		for input_texture_rect_input_event in input_texture_rect.input_events:
			
			if event.is_class(input_texture_rect_input_event):
				
				value_default = event
				value_default_class_name = input_texture_rect_input_event
				
				input_texture_rect.event_current = value_default
				
				return
	
	return

func value_default_set_to() -> void:
	
	input_texture_rect.event_current_change(value_default, value_default_class_name)
	
	return

func options_save_file_key_get() -> String:
	return "%s_%d" % [name, input_texture_rect.input_type]

func options_save_file_value_get() -> Array:
	return input_texture_rect.event_current_data_get()

func options_save_file_value_set(value) -> Error:
	
	if not value is Array:
		return ERR_INVALID_DATA
	
	return input_texture_rect.event_current_load(value)

func _ready() -> void:
	
	super()
	
	if Engine.is_editor_hint():
		return
	
	options_save_file_load()
	
	return
