extends TextureRect

signal input_active
signal input_inactive

var button_pressed := false : set = button_pressed_set

var input_type: Inputs.InputTypes

var event_datas_valid_ranges: Dictionary

var event_current: InputEvent
var input_events: Dictionary

var inputs_paths: Array[String]

func texture_set(value: Texture2D, input_index := -1) -> void:
	
	texture = value
	Globals.inputs_textures[input_index][owner.action] = texture
	
	return

func inputs_paths_get(inputs_directory_path: String) -> Array[String]:
	return [inputs_directory_path + "/%s.png"]

func inputs_paths_set(inputs_directory_path := "") -> void:
	
	inputs_paths = inputs_paths_get(inputs_directory_path)
	
	return

func button_pressed_set(value: bool) -> void:
	
	button_pressed = value
	
	if button_pressed:
		input_active.emit()
	
	else:
		input_inactive.emit()
	
	return

func event_current_data_get() -> Array:
	return []

func event_current_change(event: InputEvent, input_event: String) -> void:
	
	if event_current:
		InputMap.action_erase_event(owner.action, event_current)
	
	event_current = event
	
	if event_current:
		
		InputMap.action_add_event(owner.action, event_current)
		owner.options_save_file_save()
		
		texture_set(load(input_events[input_event][1].call(event)))
	
	else:
		texture_set(null)
	
	return

func event_current_load(event_data: Array) -> Error:
	
	if not len(event_data) in event_datas_valid_ranges:
		return ERR_INVALID_DATA
	
	for value in event_data:
		
		if not value is int:
			return ERR_INVALID_DATA
	
	for event_data_valid_range in event_datas_valid_ranges[len(event_data)]:
		
		if event_data_valid_range[0] <= event_data[0] and event_data[0] < event_data_valid_range[1]:
			return OK
	
	return ERR_INVALID_DATA

func input_update(event: InputEvent) -> void:
	
	if not button_pressed:
		return
	
	if Globals.v_button_pressed_last != owner:
		button_pressed = false
		return
	
	for input_event in input_events:
		
		if event.is_class(input_event):
			
			if not input_events[input_event][0].call(event):
				return
			
			accept_event()
			
			button_pressed = false
			
			event_current_change(event, input_event)
			
			return
	
	return

func _ready() -> void:
	
	inputs_paths_set()
	
	return

func _input(event: InputEvent) -> void:
	
	input_update(event)
	
	return

func _on_button_pressed() -> void:
	
	button_pressed = not button_pressed
	
	return
