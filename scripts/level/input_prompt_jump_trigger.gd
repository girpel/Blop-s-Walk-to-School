extends Area2D

var timer_trigger_timed_out := false

@onready var timer_trigger := $Timers/Trigger
@onready var timer_transition := $Timers/Transition

func _physics_process(_delta: float) -> void:
	
	if Globals.player.state_machine.state_current is StatePlayerJump:
		process_mode = Node.PROCESS_MODE_DISABLED
	
	return

func _on_body_entered(_body: Node2D) -> void:
	
	timer_trigger.start()
	
	return

func _on_trigger_timeout() -> void:
	
	timer_trigger_timed_out = true
	
	return

func _on_title_screen_reentered() -> void:
	
	timer_trigger.paused = true
	
	return

func _on_title_screen_start_started() -> void:
	
	if timer_trigger_timed_out:
		timer_transition.start()
	
	timer_trigger.paused = false
	
	return
