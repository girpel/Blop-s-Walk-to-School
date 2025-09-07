extends AnimatedSprite2D

signal playing
signal playing_backwards

signal tree_paused
signal tree_continued

var body_current: Node2D
var body_current_position_clamp_rect: Rect2

@onready var tree := get_tree()
@onready var game_camera_2d := tree.root.get_camera_2d()
@onready var player_camera_2d: Camera2D

func body_current_update() -> void:
	
	if not body_current:
		return
	
	if not body_current.interact_just:
		return
	
	if tree.paused:
		
		play_backwards()
		playing_backwards.emit()
		
		tree.paused = false
		
		RenderingServer.global_shader_parameter_set("time_scale", 1)
		body_current.position_clamp_rect = body_current_position_clamp_rect
		
		AudioServer.set_bus_volume_db(Globals.AudioBuses.AMBIENCE_DEFAULT, Globals.VOLUME_DB_MAX)
		
		tree_continued.emit()
		
		player_camera_2d.top_level = false
		player_camera_2d.position = Vector2.ZERO
	
	elif Globals.coins_count == Globals.coins_count_max:
		
		play()
		playing.emit()
		
		tree.paused = true
		
		PhysicsServer2D.set_active(true)
		RenderingServer.global_shader_parameter_set("time_scale", 0)
		
		body_current_position_clamp_rect = body_current.position_clamp_rect
		body_current.position_clamp_rect = Rect2(game_camera_2d.get_screen_center_position() - Globals.VIEWPORT_SIZE_HALF, Globals.VIEWPORT_SIZE)
		
		AudioServer.set_bus_volume_db(Globals.AudioBuses.AMBIENCE_DEFAULT, Globals.VOLUME_DB_MIN)
		
		tree_paused.emit()
		
		var player_camera_2d_global_position := player_camera_2d.global_position
		player_camera_2d.top_level = true
		player_camera_2d.global_position = player_camera_2d_global_position
	
	return

func _ready() -> void:
	
	await owner.ready
	player_camera_2d = Globals.player.get_node("Camera2D")
	
	return

func _process(_delta: float) -> void:
	
	body_current_update()
	
	return

func _on_area_2d_body_entered(body: Node2D) -> void:
	
	if Globals.coins_count == Globals.coins_count_max or (Globals.coins_count > Globals.coins_count_max and tree.paused):
		body.sprite_exclamation_mark.visible = true
	
	body_current = body
	
	return

func _on_area_2d_body_exited(body: Node2D) -> void:
	
	body.sprite_exclamation_mark.visible = false
	body_current = null
	
	return
