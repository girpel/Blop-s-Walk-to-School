extends Node

class_name StateMachine

signal transitioned (state: State)

@export var state_initial: NodePath

var states: Array[Node] = []

@onready var state_current := get_node(state_initial)
@onready var state_previous := state_current

func transition(state_index: int) -> void:
	
	state_previous = state_current
	
	if states[state_index].enter():
		
		state_current = states[state_index]
		transitioned.emit(state_current)
	
	state_previous.exit()
	
	return

func states_set() -> void:
	
	states.resize(get_child_count())
	
	for child in get_children():
		states[child.state] = child
	
	return

func _ready() -> void:
	
	states_set()
	
	await get_parent().ready
	transition(state_current.state)
	
	return

func _process(delta: float) -> void:
	
	state_current.process(delta)
	
	return

func _physics_process(delta: float) -> void:
	
	state_current.physics_process(delta)
	
	return
