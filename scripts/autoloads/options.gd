extends Node

signal window_mode_changed (window_mode: DisplayServer.WindowMode)
signal color_palette_changed (colors: Array)
signal particles_collisions_changed (enabled: bool)
signal water_shader_visiblilty_changed (visible: bool)
signal controller_index_changed (index: int)

const _COLOR_PALETTES: Array[Array] = [
	[Color("000000"), Color("ffffff")],
	[Color("180621"), Color("ffffe0")],
	[Color("030008"), Color("ffffe0")],
	[Color("121212"), Color("d9d9d9")],
	[Color("0b2e23"), Color("a4eb88")],
	[Color("3d0707"), Color("ff6d2e")],
	[Color("42078f"), Color("d8a2f5")],
	[Color("422815"), Color("d1a964")],
	[Color("411f4d"), Color("e5e5ac")],
	[Color("e063de"), Color("124499")],
	[Color("124499"), Color("e063de")],
	[Color("c20817"), Color("140002")],
	[Color("14171a"), Color("95d2d3")],
	[Color("23306e"), Color("afd4fa")],
	[Color("0d290d"), Color("c5e635")],
	[Color("000000"), Color("4af626")],
	[Color("0d0d0d"), Color("121212")],
	[Color("ffffff"), Color("000000")]
]

const _AUDIO_SELECTION_SIZE := 10.0

var jump_hold := false
var jump_uniform := false

var window_mode: DisplayServer.WindowMode : set = _window_mode_set
var _window_size: Vector2i : set = _window_size_set

var _window_mode_windowed_last: DisplayServer.WindowMode

var _gpu_particles_2ds_collision_mode := {}

@onready var _window := get_window()

func fullscreen_update() -> void:
	
	if Inputs.fullscreen_just:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if window_mode == DisplayServer.WINDOW_MODE_WINDOWED else DisplayServer.WINDOW_MODE_WINDOWED)
	
	return

func _window_size_set(value: Vector2i) -> void:
	
	if Globals.web_export:
		return
	
	_window_size = value
	
	_window.size = _window_size
	_window.move_to_center()
	
	return

func _window_mode_set(value: DisplayServer.WindowMode) -> void:
	
	if window_mode == value:
		return
	
	window_mode = value
	window_mode_changed.emit(window_mode)
	
	match window_mode:
		
		DisplayServer.WindowMode.WINDOW_MODE_WINDOWED:
			_window_mode_windowed_last = window_mode
			_window_size = _window_size
		
		DisplayServer.WindowMode.WINDOW_MODE_MAXIMIZED:
			_window_mode_windowed_last = window_mode
	
	return

func _ready() -> void:
	
	process_mode = PROCESS_MODE_ALWAYS
	
	for gpu_particle_2ds_collision in get_tree().get_nodes_in_group("gpu_particles_2ds_collision"):
		_gpu_particles_2ds_collision_mode[gpu_particle_2ds_collision] = gpu_particle_2ds_collision.process_material.collision_mode
	
	return

func _process(_delta: float) -> void:
	
	window_mode = DisplayServer.window_get_mode()
	fullscreen_update()
	
	return

func _audio_bus_volume_db_set(audio_bus_index: Globals.AudioBuses, selection_index: int) -> void:
	
	AudioServer.set_bus_volume_db(audio_bus_index, linear_to_db(selection_index / _AUDIO_SELECTION_SIZE))
	
	return

func _on_jump_hold_selection_changed(selection_index: int) -> void:
	
	jump_hold = bool(selection_index)
	
	return

func _on_jump_height_selection_changed(selection_index: int) -> void:
	
	jump_uniform = bool(selection_index)
	
	return

func _on_color_palette_selection_changed(selection_index: int) -> void:
	
	color_palette_changed.emit(_COLOR_PALETTES[selection_index])
	
	return

func _on_window_mode_selection_changed(selection_index: int) -> void:
	
	DisplayServer.window_set_mode([DisplayServer.WINDOW_MODE_FULLSCREEN, _window_mode_windowed_last][selection_index])
	
	return

func _on_window_scale_selection_changed(selection_index: int) -> void:
	
	_window_size = Globals.VIEWPORT_SIZE * (selection_index + 1)
	
	return

func _on_particle_collisions_selection_changed(selection_index: int) -> void:
	
	for gpu_particle_2ds_collision in _gpu_particles_2ds_collision_mode:
		gpu_particle_2ds_collision.process_material.collision_mode = _gpu_particles_2ds_collision_mode[gpu_particle_2ds_collision] * selection_index
	
	particles_collisions_changed.emit(bool(selection_index))
	
	return

func _on_water_shaders_selection_changed(selection_index: int) -> void:
	
	water_shader_visiblilty_changed.emit(bool(selection_index))
	
	return

func _on_master_selection_changed(selection_index: int) -> void:
	
	_audio_bus_volume_db_set(Globals.AudioBuses.MASTER, selection_index)
	
	return

func _on_ambience_selection_changed(selection_index: int) -> void:
	
	_audio_bus_volume_db_set(Globals.AudioBuses.AMBIENCE, selection_index)
	
	return

func _on_sound_effects_selection_changed(selection_index: int) -> void:
	
	_audio_bus_volume_db_set(Globals.AudioBuses.SOUND_EFFECTS, selection_index)
	
	return

func _on_user_interface_selection_changed(selection_index: int) -> void:
	
	_audio_bus_volume_db_set(Globals.AudioBuses.UI, selection_index)
	
	return

func _on_controller_selection_changed(selection_index: int) -> void:
	
	controller_index_changed.emit(selection_index)
	
	return
