extends RigidBody2DCollisionBall

signal transport

const POSITION_Y_MAX := 3575.5
const COLLISION_TRANSPORT_COUNTER_MAX := 16

var collision_transport_counter := 0

func position_update() -> void:
	
	if position.y < POSITION_Y_MAX:
		return
	
	process_mode = PROCESS_MODE_DISABLED
	transport.emit()
	
	return

func _process(delta: float) -> void:
	
	super(delta)
	position_update()
	
	return

func _physics_process(delta: float) -> void:
	
	if collision_transport_counter == COLLISION_TRANSPORT_COUNTER_MAX:
		return super(delta)
	
	collision_transport_counter += 1
	
	return

func _on_science_tube_animation_finished() -> void:
	
	process_mode = PROCESS_MODE_INHERIT
	
	position = position_initial
	reset()
	
	return
