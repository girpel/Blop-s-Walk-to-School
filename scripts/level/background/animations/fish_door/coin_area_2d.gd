extends Area2D

signal entered

@onready var tree := get_tree()

func _on_body_entered(_body: Node2D) -> void:
	
	entered.emit()
	set_deferred("monitoring", false)
	
	return
