extends "../label_dialouge.gd"

signal finished

@onready var text_initial := text

func text_set(value: String) -> void:
	
	text_raw = text_initial % value
	
	return

func text_update(delta: float) -> void:
	
	if visible_characters == text_length:
		
		finished.emit()
		process_mode = PROCESS_MODE_DISABLED
		
		return
	
	super(delta)
	
	return
