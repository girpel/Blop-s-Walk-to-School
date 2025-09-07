extends Node

class_name State

var state: int

@onready var state_machine := get_parent()

func enter() -> bool:
	return true

func state_change() -> bool:
	return false

func process(_delta: float) -> void:
	return

func physics_process(_delta: float) -> void:
	return

func exit() -> void:
	return
