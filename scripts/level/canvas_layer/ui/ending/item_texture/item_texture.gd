extends TextureRect

signal finished

@export_dir var items_textures_directory_path: String

const ITEMS_SPECIAL_CHARACTERS := "()-:'"

const SCALE_TWEEN_SCALE_STEP := 0.016
const SCALE_TWEEN_DURATION := 0.65

@onready var center := position + size / 2

func texture_set(item: String) -> void:
	
	scale = Vector2.ZERO
	
	if Globals.coins_count == 0:
		return
	
	var item_filename := item
	
	for character in ITEMS_SPECIAL_CHARACTERS:
		item_filename = item_filename.replace(character, '')
	
	texture = load("%s/%s.png" % [items_textures_directory_path, item_filename.to_snake_case()]) 
	reset_size()
	
	return

func scale_centered_set(scale_component: float) -> void:
	
	scale = snapped(scale_component, SCALE_TWEEN_SCALE_STEP) * Vector2.ONE
	position = center - size * scale / 2
	
	return

func _on_delay_timeout() -> void:
	
	var scale_tween := create_tween()
	scale_tween.finished.connect(emit_signal.bind("finished"))
	
	scale_tween.tween_method(scale_centered_set, 0.0, 1.0, SCALE_TWEEN_DURATION).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	
	return
