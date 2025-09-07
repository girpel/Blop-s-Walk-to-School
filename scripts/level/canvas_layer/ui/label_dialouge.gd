extends Label

signal dialouge_audio_stream_play

const TEXT_DELAY_CHARACTERS := "{}"

const TEXT_DELAY_TIMER_MAX_DEFAULT := 0.0166
const TEXT_DELAY_TIMER_MAXES := {',': 0.2, '.': 0.28, '?': 0.28, '!': 0.28, '"': 0.28}

var text_raw := '' : set = text_raw_set
var text_length := 0
var text_delay_characters_counter := 0

var text_character: String : get = text_character_get

var text_delay := false
var text_delay_timer := 0.0

func text_raw_set(value: String) -> void:
	
	text_raw = value
	
	text = text_raw
	for text_delay_character in TEXT_DELAY_CHARACTERS:
		text = text.replace(text_delay_character, "")
	
	text_length = text.length()
	text_delay_characters_counter = 0
	
	text_delay_timer = 0
	text_delay = false
	
	visible_characters = 1
	
	return

func text_character_get() -> String:
	return text_raw[visible_characters + text_delay_characters_counter - 1]

func text_delay_timer_max_get() -> float:
	
	var text_delay_character_index := TEXT_DELAY_CHARACTERS.find(text_character)
	
	if text_delay_character_index != -1:
		
		text_delay_characters_counter += 1
		
		if text_delay_character_index == 0:
			text_delay = true
		
		else:
			text_delay = false
	
	return TEXT_DELAY_TIMER_MAXES[text_character] if text_delay and text_character in TEXT_DELAY_TIMER_MAXES else TEXT_DELAY_TIMER_MAX_DEFAULT

func text_update(delta: float) -> void:
	
	if visible_characters == text_length:
		return
	
	var text_delay_timer_max_current := text_delay_timer_max_get()
	
	if text_delay_timer < text_delay_timer_max_current:
		text_delay_timer += delta
		return
	
	var dialouge_audio_stream_play_oneshot := true
	
	while text_delay_timer >= text_delay_timer_max_current:
		
		text_delay_timer -= text_delay_timer_max_current
		
		visible_characters += 1
		
		if text_character != ' ' and dialouge_audio_stream_play_oneshot:
			
			dialouge_audio_stream_play_oneshot = false
			dialouge_audio_stream_play.emit()
		
		if visible_characters == text_length:
			break
		
		text_delay_timer_max_current = text_delay_timer_max_get()
	
	return

func _process(delta: float) -> void:
	
	text_update(delta)
	
	return
