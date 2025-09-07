@tool
extends VButtonCenterExtend

class_name VButtonCenterExtendSelect

signal selection_changed (selection_index: int)

@export var selections: Array[String] = []
@export var selection_index_start := 0
@export var selection_custom_minimum_size_x := 0
@export var selection_wrap := false

var selection_index := 0 : set = selection_index_set

@onready var selections_size := selections.size()
@onready var selections_size_dec = selections_size - 1
@onready var selection := $Button/HBoxContainer/HBoxContainer/ButtonSelect/Selection

@onready var texture_button_left := $Button/HBoxContainer/HBoxContainer/ButtonSelect/TextureButtonLeft
@onready var texture_button_right := $Button/HBoxContainer/HBoxContainer/ButtonSelect/TextureButtonRight

@onready var texture_buttons_select: Array[TextureButton] = [texture_button_left, texture_button_right]

func value_default_set() -> void:
	
	value_default = selection_index_start
	
	return

func value_default_set_to() -> void:
	
	selection_index = value_default
	
	return

func options_save_file_key_get() -> String:
	return name

func options_save_file_value_get() -> int:
	return selection_index

func options_save_file_value_set(value) -> Error:
	
	if not value is int:
		return ERR_INVALID_DATA
	
	if not (0 <= value and value < selections_size):
		return ERR_INVALID_DATA
	
	selection_index = value
	return OK

func selection_index_set(value: int) -> void:
	
	selection_index = value
	selection.text = selections[selection_index]
	
	options_save_file_save()
	
	selection_changed.emit(selection_index)
	
	return

func signal_connect_string(signal_var: Signal, object_target: Object) -> void:
	
	signal_var.connect(object_target.get("_on_%s_%s" % [signal_var.get_object().name.to_snake_case(), signal_var.get_name()]))
	
	return

func texture_buttons_select_set() -> void:
	
	if selection_wrap:
		
		for texture_button_select_index in texture_buttons_select.size():
			texture_buttons_select[texture_button_select_index].pressed.connect(_on_texture_button_select_pressed_wrap.bind(texture_button_select_index * 2 - 1))
	
	else:
		
		for texture_button_select in texture_buttons_select:
			signal_connect_string(texture_button_select.pressed, self)
		
		if selection_index == 0:
			texture_button_left.disabled = true
		
		if selection_index == selections_size_dec:
			texture_button_right.disabled = true
	
	return

func _ready() -> void:
	
	super()
	
	if Engine.is_editor_hint():
		return
	
	signal_connect_string(selection_changed, Options)
	options_save_file_load()
	
	selection.custom_minimum_size.x = selection_custom_minimum_size_x
	
	texture_buttons_select_set()
	
	return

func _process(delta: float) -> void:
	
	super(delta)
	
	if Engine.is_editor_hint():
		
		if selections:
			selection.text = selections[selection_index_start]
		
		selection.custom_minimum_size.x = selection_custom_minimum_size_x
		
		return
	
	return

func _on_texture_button_select_pressed_wrap(selection_index_change: int) -> void:
	
	selection_index = wrapi(selection_index + selection_index_change, 0, selections_size)
	
	selection.change_tween(selection_index_change)
	texture_buttons_select[(selection_index_change + 1) / 2.0].change_tween()
	
	return

func _on_texture_button_left_pressed() -> void:
	
	if selection_index == selections_size_dec:
		texture_button_right.disabled = false
	
	selection_index -= 1
	
	if selection_index == 0:
		texture_button_left.disabled = true
	
	selection.change_tween(-1)
	texture_button_left.change_tween()
	
	return

func _on_texture_button_right_pressed() -> void:
	
	if selection_index == 0:
		texture_button_left.disabled = false
	
	selection_index += 1
	
	if selection_index == selections_size_dec:
		texture_button_right.disabled = true
	
	selection.change_tween(1)
	texture_button_right.change_tween()
	
	return
