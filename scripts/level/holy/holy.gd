extends Area2D

signal start
signal end

var body_current: Node2D
var started := false

func body_current_update() -> void:
	
	if not body_current:
		return
	
	match body_current.state_machine.state_current.state:
		
		StatePlayer.States.SIT:
			
			if started:
				return
			
			started = true
			start.emit()
		
		_:
			
			if not started:
				return
			
			started = false
			end.emit() 
	
	return

func _process(_delta: float) -> void:
	
	body_current_update()
	
	return

func _on_body_entered(body: Node2D) -> void:
	
	body_current = body
	
	return

func _on_body_exited(_body: Node2D) -> void:
	
	body_current = null
	
	return
