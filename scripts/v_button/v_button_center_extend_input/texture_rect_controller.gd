extends "texture_rect.gd"

@export var inputs_directory_paths: Array[String]

var inputs_directories_paths_index := 0 
var inputs_paths_default: Array[String]

var axis_pressed := false

func texture_set(value: Texture2D, input_index := 1) -> void:
	return super(value, input_index)

func inputs_paths_get(inputs_directory_path: String) -> Array[String]:
	
	var inputs_path := super(inputs_directory_path)[0]
	
	return [inputs_path % "a_%d%d", inputs_path % "b_%d"]

func inputs_paths_set(inputs_directory_path := inputs_directory_paths[inputs_directories_paths_index]) -> void:
	return super(inputs_directory_path)

func input_path_get(inputs_path_index: int, input_name: Array) -> String:
	
	var input_path := inputs_paths[inputs_path_index] % input_name
	
	if FileAccess.file_exists(input_path + ".import"):
		return input_path
	
	return inputs_paths_default[inputs_path_index] % input_name

func event_current_data_get() -> Array:
	
	if event_current is InputEventJoypadButton:
		return [event_current.button_index]
	
	return [event_current.axis, event_current.axis_value]


func event_current_load(event_data: Array) -> Error:
	
	var event_data_error := super(event_data)
	
	if event_data_error:
		return event_data_error
	
	var event: InputEvent
	
	if len(event_data) == 1:
		event = InputEventJoypadButton.new()
		event.button_index = event_data[0]
	
	else:
		
		if abs(event_data[1]) != 1:
			return ERR_INVALID_DATA
		
		event = InputEventJoypadMotion.new()
		event.axis = event_data[0]
		event.axis_value = event_data[1]
	
	event_current_change(event, event.get_class())
	
	return OK

func axis_pressed_get(event: InputEventJoypadMotion) -> bool:
	
	axis_pressed = abs(event.axis_value) > Inputs.AXIS_DEADZONE and (event.axis >= 0 and event.axis < JOY_AXIS_SDL_MAX)
	event.axis_value = sign(event.axis_value)
	
	return axis_pressed 

func axis_path_get(event: InputEventJoypadMotion) -> String:
	return input_path_get(0, [event.axis, (event.axis_value + 1) / 2])

func button_pressed_get(event: InputEventJoypadButton) -> bool:
	return event.pressed

func button_path_get(event: InputEventJoypadButton) -> String:
	return input_path_get(1, [event.button_index])

func inputs_directories_paths_index_update() -> void:
	
	if inputs_directories_paths_index == Options.controller_index:
		return
	
	inputs_directories_paths_index = Options.controller_index
	inputs_paths_set()
	
	if not event_current:
		return
	
	for input_event in input_events:
		
		if event_current.is_class(input_event):
			texture_set(load(input_events[input_event][1].call(event_current)))
	
	return

func input_event_axis_update(event: InputEvent) -> void:
	
	if not axis_pressed:
		return
	
	if not event is InputEventJoypadMotion:
		return
	
	if event.axis != event_current.axis:
		return
	
	if abs(event.axis_value) < Inputs.AXIS_DEADZONE:
		axis_pressed = false
		return
	
	accept_event()
	
	return

func _init() -> void:
	
	input_type = Inputs.InputTypes.CONTROLLER
	
	event_datas_valid_ranges = {
		1: [[0, 128]],
		2: [[0, 10]]
	}
	
	input_events = {
		"InputEventJoypadMotion": [axis_pressed_get, axis_path_get],
		"InputEventJoypadButton": [button_pressed_get, button_path_get]
	}
	
	return

func _ready() -> void:
	
	inputs_paths_default = inputs_paths_get(inputs_directory_paths[0])
	
	inputs_directories_paths_index_update()
	return super()

func _process(_delta: float) -> void:
	
	inputs_directories_paths_index_update()
	
	return

func _input(event: InputEvent) -> void:
	
	super(event)
	input_event_axis_update(event)
	
	return
