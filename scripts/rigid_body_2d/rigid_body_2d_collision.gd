extends RigidBody2D

class_name RigidBody2DCollision

const COLLISION_PLAYER_COUNTER_MAX := 4

var collision_player := true
var collision_player_counter := 0

@onready var collision := $Collision

func collision_player_update() -> void:
	
	if collision_player_counter == COLLISION_PLAYER_COUNTER_MAX:
		collision_player = false
		return
	
	collision_player_counter = collision_player_counter + 1
	
	return

func _process(_delta: float) -> void:
	
	collision_player_update()
	
	return

func _collision_player() -> void:
	
	collision_player_counter = 0
	
	if collision_player:
		return
	
	collision_player = true
	
	collision.play()
	
	return
