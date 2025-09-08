extends "texture_rect.gd"

@export_dir var keys_directory_path: String

func texture_set(value: Texture2D, input_index := 0) -> void:
	return super(value, input_index)

func event_current_data_get() -> Array:
	return [event_current.physical_keycode]

func event_current_load(event_data: Array) -> Error:
	
	var event_data_error := super(event_data)
	
	if event_data_error:
		return event_data_error
	
	var event := InputEventKey.new()
	event.physical_keycode  = event_data[0] as Key
	
	event_current_change(event, event.get_class())
	
	return OK

func key_pressed_get(event: InputEventKey) -> bool:
	return event.pressed

func key_path_get(event: InputEventKey) -> String:
	return inputs_paths[0] % event.as_text_physical_keycode().to_snake_case()

func _init() -> void:
	
	input_type = Inputs.InputTypes.KEYBOARD
	
	event_datas_valid_ranges = {1: [[4194305, 4194367], [4194433, 4194448], [4194370, 4194372], [4194373, 4194374], [4194376, 4194383], [4194388, 4194420], [32, 97], [123, 127], [165, 166], [167, 168]]}
	input_events = {"InputEventKey": [key_pressed_get, key_path_get]}
	
	return

func _ready() -> void:
	
	inputs_paths_set(keys_directory_path)
	
	return
