extends Sprite2D

@onready var position_x_initial := position.x

func _process(_delta: float) -> void:
	
	position.x = -position_x_initial * owner.h_direction
	
	return
