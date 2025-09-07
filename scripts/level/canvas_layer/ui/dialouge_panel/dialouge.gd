extends "../label_dialouge.gd"

signal interact_end
signal interact_end_ending

const TEXT_SKIP_TIMER_MAX := 0.2

var interact := Inputs.interact
var interact_just := Inputs.interact_just
var interact_pressed := false

var text_array: PackedStringArray = [] : set = text_array_set
var text_array_index := 0 : set = text_array_index_set
var text_array_size := 0

var text_skip_timer := 0.0

var text_set := false

func text_array_index_set(value: int) -> void:
	
	text_array_index = value
	text_raw = text_array[text_array_index]
	
	return

func text_array_set(value: PackedStringArray) -> void:
	
	text_set = true
	
	text_array = value
	text_array_size = text_array.size()
	text_array_index = 0
	
	return

func input_get() -> void:
	
	if text_set:
		
		text_set = false
		
		return
	
	if Inputs.input_disable_current:
		
		interact = false
		interact_just = false
		
		interact_pressed = false
		
		return
	
	interact_just = Inputs.interact_just
	
	if interact_pressed:
		
		if Inputs.interact_just_released:
			interact_pressed = false
		
		interact = Inputs.interact
	
	elif interact_just:
		interact_pressed = true
	
	return

func text_update(delta: float) -> void:
	
	if interact_just or (interact and text_skip_timer == TEXT_SKIP_TIMER_MAX):
		
		text_skip_timer = 0
		
		if visible_characters < text_length:
			
			visible_characters = text_length
			
			return
		
		if text_array_index < text_array_size - 1:
			
			text_array_index += 1
			
			return
		
		if Globals.ending:
			
			interact_end_ending.emit()
			
			return
		
		interact_end.emit()
		
		return
	
	super(delta)
	
	return

func _process(delta: float) -> void:
	
	super(delta)
	text_skip_timer = min(text_skip_timer + delta, TEXT_SKIP_TIMER_MAX)
	
	input_get()
	
	return
