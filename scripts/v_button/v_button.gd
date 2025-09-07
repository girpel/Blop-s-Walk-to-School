@tool
extends MarginContainer

class_name VButton

signal button_down
signal button_up
signal pressed
signal toggled (button_pressed: bool)

@export_multiline var text := ""

@export var shortcut: Shortcut

@export var stream_focus: AudioStream
@export var stream_pressed: AudioStream

@export var disabled := false : set = disabled_set

var button_path: NodePath

var button_focus_neighbor_top: Button
var button_focus_neighbor_bottom: Button

@onready var v_buttons_container := get_parent()

@onready var button := $Button
@onready var arrows := $Control/Arrows

@onready var node_text: Node = button

func disabled_set(value: bool) -> void:
	
	if disabled == value:
		return
	
	disabled = value
	
	if not is_node_ready():
		return
	
	visible = not disabled
	
	if Engine.is_editor_hint():
		return
	
	disabled_button_focus_neighbors_set()
	
	return

func button_focus_neighbors_set(node_paths: Array[NodePath]) -> void:
	
	if Engine.is_editor_hint():
		return
	
	if button_focus_neighbor_top:
		button_focus_neighbor_top.focus_neighbor_bottom = node_paths[0]
	
	if button_focus_neighbor_bottom:
		button_focus_neighbor_bottom.focus_neighbor_top = node_paths[1]
	
	return

func disabled_button_focus_neighbors_set() -> void:
	
	if disabled:
		
		button_focus_neighbors_set([button.focus_neighbor_bottom, button.focus_neighbor_top])
		
		if button.has_focus():
			v_buttons_container.grab_focus_skip()
		
		process_mode = PROCESS_MODE_DISABLED
	
	else:
		button_focus_neighbors_set([button_path, button_path])
		process_mode = PROCESS_MODE_INHERIT
	
	return

func signal_emit(argument, signal_name: String) -> void:
	
	emit_signal(signal_name, argument)
	
	return

func _ready() -> void:
	
	if Engine.is_editor_hint():
		return
	
	node_text.text = text 
	button.shortcut = shortcut
	
	button_path = button.get_path()
	
	await v_buttons_container.ready
	
	button_focus_neighbor_top = get_node(button.focus_neighbor_top) if button.focus_neighbor_top else null
	button_focus_neighbor_bottom = get_node(button.focus_neighbor_bottom) if button.focus_neighbor_bottom else null
	
	disabled_button_focus_neighbors_set()
	
	return

func _process(_delta: float) -> void:
	
	if Engine.is_editor_hint():
		
		node_text.text = text
		
		return
	
	return

func _on_button_focus_entered() -> void:
	
	arrows.focus_tween(sign(global_position.y - Globals.v_button_last_global_position_y), button.focus_skip)
	Globals.v_button_last_global_position_y = global_position.y
	
	return

func _on_button_focus_exited() -> void:
	
	if disabled:
		v_buttons_container.focus()
	
	return
