extends Node2D

@export_dir var chunks_directory_path := ""

@onready var game_camera_2d := get_tree().root.get_camera_2d()

@onready var chunks_sprites := get_children()
@onready var chunks_sprites_size := chunks_sprites.size()
@onready var chunk_sprites_size_root := int(sqrt(chunks_sprites_size))

@onready var chunks_path := chunks_directory_path + "/%d_%d.png"
@onready var chunk_size: Vector2 = load("%s/%s" % [chunks_directory_path, DirAccess.get_files_at(chunks_directory_path)[-1].get_basename()]).get_size()

var chunk_coordinates_start_previous = -Vector2.ONE

func chunk_sprites_update() -> void:
	
	var chunk_coordinates_start: Vector2 = ((game_camera_2d.get_screen_center_position() - (game_camera_2d.offset + position)) / chunk_size).floor()
	
	for chunk_sprite_index in chunks_sprites_size:
		
		var chunk_coordinates = chunk_coordinates_start + Vector2(chunk_sprite_index % chunk_sprites_size_root, floor(chunk_sprite_index / chunk_sprites_size_root))
		chunks_sprites[chunk_sprite_index].position = chunk_coordinates * chunk_size
		
		if chunk_coordinates_start == chunk_coordinates_start_previous:
			continue
		
		var chunk_path := chunks_path % [chunk_coordinates.x, chunk_coordinates.y]
		
		if FileAccess.file_exists(chunk_path + ".import"):
			chunks_sprites[chunk_sprite_index].texture = load(chunk_path)
			continue
		
		chunks_sprites[chunk_sprite_index].texture = null
	
	chunk_coordinates_start_previous = chunk_coordinates_start
	
	return

func _ready() -> void:
	
	position = Globals.VIEWPORT_SIZE_HALF
	
	return

func _process(_delta: float) -> void:
	
	chunk_sprites_update()
	
	return
