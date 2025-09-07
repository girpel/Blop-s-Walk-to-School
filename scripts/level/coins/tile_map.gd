extends TileMap

signal collected

var pool_jump_is := true
var pool_jump_y_last := -1

var layers_pattern: Array[TileMapPattern] = []

@onready var layers_count := get_layers_count()
@onready var audio_stream_player := $AudioStreamPlayer
@onready var pool_jump := $PoolJump

func reset() -> void:
	
	for layer_index in layers_count:
		set_pattern(layer_index, Vector2i.ZERO, layers_pattern[layer_index])
	
	pool_jump_is = true
	pool_jump_y_last = -1
	
	return

func layers_pattern_set() -> void:
	
	for layer_index in layers_count:
		layers_pattern.append(get_pattern(layer_index, get_used_cells(layer_index) + [Vector2i.ZERO]))
	
	return

func coins_count_max_set() -> void:
	
	for layer_index in layers_count:
		Globals.coins_count_max += get_used_cells(layer_index).size()
	
	return

func pool_jump_is_update() -> void:
	
	if pool_jump_y_last == -1:
		return
	
	if Globals.player.state_machine.state_current is StatePlayerJump:
		pool_jump_is = false
	
	return

func pool_jump_update() -> void:
	
	if not pool_jump_is:
		return
	
	if get_used_cells(1).size() != 0:
		return
	
	pool_jump_is = false
	pool_jump.play()
	
	return

func _ready() -> void:
	
	layers_pattern_set()
	coins_count_max_set()
	
	return

func _process(_delta: float) -> void:
	
	pool_jump_is_update()
	pool_jump_update()
	
	return

func _on_collect(body_rid: RID) -> void:
	
	var body_coords := get_coords_for_body_rid(body_rid)
	var body_layer := get_layer_for_body_rid(body_rid)
	
	erase_cell(body_layer, body_coords)
	collected.emit()
	
	if body_layer != 1:
		return
	
	if pool_jump_y_last > body_coords.y:
		pool_jump_is = false
		return
	
	pool_jump_y_last = body_coords.y
	
	return
