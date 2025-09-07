extends Button

@export var focus_tween_value: int
@export var focus_tween_duration: float

@export var focus_tween_property: String

var hovered := false
var focus_hovered := false

var focus_skip := false

@onready var v_buttons_container := owner.get_parent()
@onready var arrows := get_children()

@onready var tree := get_tree()

func grab_focus_skip() -> void:
	
	focus_skip = true
	grab_focus()
	
	return

func focus_tween(final_val: int) -> void:
	
	create_tween().set_pause_mode(Tween.TWEEN_PAUSE_PROCESS).tween_property(self, focus_tween_property, final_val, 0.0 if focus_skip else focus_tween_duration)
	set_deferred("focus_skip", false)
	
	return

func focus_update() -> void:
	
	if has_focus() or Input.is_mouse_button_pressed(button_mask):
		return
	
	var hovered_current := is_hovered()
	
	if hovered == hovered_current:
		return
	
	hovered = hovered_current
	
	if hovered:
		focus_hovered = true
		grab_focus()
	
	return

func _process(_delta: float) -> void:
	
	focus_update()
	
	return

func _pressed() -> void:
	
	Globals.v_button_pressed_last = owner
	UIAudioStreamPlayer.play_stream(owner.stream_pressed)
	
	return

func _on_focus_entered() -> void:
	
	focus_tween(focus_tween_value)
	
	if not focus_skip:
		UIAudioStreamPlayer.play_stream(owner.stream_focus, -1)
	
	return

func _on_focus_exited() -> void:
	
	focus_hovered = false
	focus_tween(0)
	
	return
