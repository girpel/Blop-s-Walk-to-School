@tool
extends HBoxContainer

class_name InputPromptsContainer

signal size_ready

const POSITION_START := Globals.VIEWPORT_SIZE + Vector2(4, -25)
const POSITION_X_PADDING := 6

var size_ready_is := false
var child_count_ready_counter := 0

var position_x_tween_in: Tween
var position_x_tween_in_duration: float

var position_x_tween_out: Tween

func position_x_end_calculate() -> float:
	return Globals.VIEWPORT_SIZE.x - (size.x + POSITION_X_PADDING)

func position_x_tween(position_x: float, duration: float) -> Tween: 
	
	var tween := create_tween().set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "position:x", position_x, duration)
	
	return tween

func signals_set() -> void:
	
	for child in get_children():
		
		child.size_ready.connect(reset_size)
		child.size_ready.connect(_on_child_size_ready)
		
		for child_signal in [child.size_changed, child.visibility_changed]:
			
			child_signal.connect(reset_size)
			child_signal.connect(_on_child_size_changed)
	
	return

func _ready() -> void:
	
	if Engine.is_editor_hint():
		return
	
	signals_set()
	
	return

func _process(_delta: float) -> void:
	
	if Engine.is_editor_hint():
		
		position = POSITION_START
		reset_size()
		
		return
	
	return

func _on_child_size_ready() -> void:
	
	child_count_ready_counter += 1
	
	if child_count_ready_counter == get_child_count():
		size_ready_is = true
		size_ready.emit()
	
	return

func _on_child_size_changed() -> void:
	
	if position.x == POSITION_START.x:
		return
	
	if position_x_tween_in:
		position_x_tween_in.kill()
	
	position.x = position_x_end_calculate()
	
	return

func _on_enter(position_x_tween_duration: float) -> void:
	
	if Engine.is_editor_hint():
		return
	
	if position_x_tween_in and position_x_tween_in.is_running():
		return
	
	if not size_ready_is:
		await size_ready
	
	process_mode = PROCESS_MODE_ALWAYS
	position = POSITION_START
	
	if position_x_tween_out:
		position_x_tween_out.kill()
	
	position_x_tween_in = position_x_tween(position_x_end_calculate(), position_x_tween_duration)
	position_x_tween_in_duration = position_x_tween_duration
	
	return

func _on_exit(position_x_tween_duration: float) -> void:
	
	if Engine.is_editor_hint():
		return
	
	if position_x_tween_out and position_x_tween_out.is_running():
		return
	
	if position_x_tween_in:
		position_x_tween_in.kill()
	
	position_x_tween_out = position_x_tween(POSITION_START.x, position_x_tween_duration)
	position_x_tween_out.finished.connect(set_process.bind(PROCESS_MODE_DISABLED))
	
	return
