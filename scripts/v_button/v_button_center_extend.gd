@tool
extends VButton

class_name VButtonCenterExtend

const OPTIONS_SAVE_FILE_PATH := "user://options.save"

var value_default

@onready var space := $Button/HBoxContainer/HBoxContainer/Space
@onready var h_box_container := $Button/HBoxContainer

func value_default_set() -> void:
	return

func value_default_set_to() -> void:
	return

func options_save_file_key_get() -> String:
	return ''

func options_save_file_value_get():
	return

func options_save_file_value_set(_value) -> Error:
	return OK

func options_save_file_data_get() -> Dictionary:
	
	var options_save_file_read := FileAccess.open(OPTIONS_SAVE_FILE_PATH, FileAccess.READ)
	
	if not options_save_file_read:
		return {}
	
	var options_save_file_data = options_save_file_read.get_var()
	
	options_save_file_read.close()
	
	return options_save_file_data

func options_save_file_save() -> void:
	
	var options_save_file_data := options_save_file_data_get()
	
	options_save_file_data[options_save_file_key_get()] = options_save_file_value_get()
	
	var options_save_file_write := FileAccess.open(OPTIONS_SAVE_FILE_PATH, FileAccess.WRITE)
	options_save_file_write.store_var(options_save_file_data)
	options_save_file_write.close()
	
	return

func options_save_file_load() -> void:
	
	if disabled:
		return
	
	var options_save_file_data := options_save_file_data_get()
	var options_save_file_key := options_save_file_key_get()
	
	if options_save_file_key in options_save_file_data:
		if not options_save_file_value_set(options_save_file_data[options_save_file_key]):
			return
	
	value_default_set_to()
	
	return

func _ready() -> void:
	
	node_text = $Button/HBoxContainer/HBoxContainer/Text
	
	if not Engine.is_editor_hint():
		value_default_set()
	
	super()
	
	return 

func _process(delta: float) -> void:
	
	super(delta)
	
	if Engine.is_editor_hint():
		
		button.custom_minimum_size.x = h_box_container.size.x if space.size.x == 0 else 0
		
		return
	
	return
