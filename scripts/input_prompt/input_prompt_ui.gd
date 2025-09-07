@tool
extends HBoxContainer

signal size_changed
signal size_ready

@export var action: StringName
@export_multiline var text := ""

@onready var label := $Label

func _ready() -> void:
	
	if Engine.is_editor_hint():
		return
	
	label.text = text
	
	return

func _process(_delta: float) -> void:
	
	if Engine.is_editor_hint():
		
		label.text = text
		
		return
	
	return
