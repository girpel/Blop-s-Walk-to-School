@tool
extends EditorImportPlugin

var editor_file_system: EditorFileSystem

enum Presets {DEFAULT}

func _get_importer_name() -> String:
	return "chunk.texture.importer"

func _get_visible_name() -> String:
	return "Chunk Texture"

func _get_recognized_extensions() -> PackedStringArray:
	return ["chunk"]

func _get_save_extension() -> String:
	return "tres"

func _get_resource_type() -> String:
	return "Resource"

func _get_preset_count() -> int:
	return Presets.size()

func _get_preset_name(preset_index: int) -> String:
	
	match preset_index:
		Presets.DEFAULT:
			return "Default"
	
	return "Unknown"

func _get_import_options(path: String, preset_index: int) -> Array[Dictionary]:
	
	match preset_index:
		Presets.DEFAULT:
			return [
				
				{"name": "chunk_size",
				"default_value": Vector2i.ONE * 256},
				
				{"name": "background_color",
				"default_value": Color.TRANSPARENT}]
	
	return []

func _get_option_visibility(path: String, option_name: StringName, options: Dictionary) -> bool:
	return true

func _get_priority() -> float:
	return 1.0

func _get_import_order() -> int:
	return 0

func _import(source_file: String, save_path: String, options: Dictionary, r_platform_variants: Array, r_gen_files: Array) -> Error:
	
	var chunks_image := Image.new()
	var chunks_image_load_error := chunks_image.load_png_from_buffer(FileAccess.get_file_as_bytes(source_file))
	
	if chunks_image_load_error:
		return chunks_image_load_error
	
	var chunks_image_format := chunks_image.get_format()
	
	var chunks_size_index := Vector2i((Vector2(chunks_image.get_size()) / Vector2(options.chunk_size)).ceil())
	
	var chunks_size := (chunks_size_index - Vector2i.ONE) * Vector2i(options.chunk_size) + Vector2i.ONE
	var chunks: Array[ImageTexture] = []
	
	var chunks_background := Image.create(options.chunk_size.x, options.chunk_size.y, false, chunks_image_format)
	chunks_background.fill(options.background_color)
	
	for chunk_x in range(0, chunks_size.x, options.chunk_size.x):
		for chunk_y in range(0, chunks_size.y, options.chunk_size.y):
			
			var chunk_image := chunks_image.get_region(Rect2i(Vector2i(chunk_x, chunk_y), options.chunk_size))
			
			if chunk_image.is_invisible() or chunk_image.compute_image_metrics(chunks_background, false).max == 0:
				chunks.append(null)
			
			else:
				chunks.append(ImageTexture.create_from_image(chunk_image))
	
	var chunks_directory_path := source_file.get_basename()
	
	if DirAccess.dir_exists_absolute(chunks_directory_path):
		
		var chunks_directory := DirAccess.open(chunks_directory_path)
		
		for chunk_file in chunks_directory.get_files():
			
			var remove_error := chunks_directory.remove(chunk_file)
			
			if remove_error:
				return remove_error
	
	else:
		
		var chunks_directory_error := DirAccess.make_dir_absolute(chunks_directory_path)
		
		if chunks_directory_error:
			return chunks_directory_error
	
	var chunks_path := chunks_directory_path + "/%d_%d.png"
	
	for chunk_index in chunks.size():
		
		if not chunks[chunk_index]:
			continue
		
		var save_error := ResourceSaver.save(chunks[chunk_index], chunks_path % [chunk_index / chunks_size_index.y, chunk_index % chunks_size_index.y])
		
		if save_error:
			return save_error
	
	editor_file_system.scan_sources()
	
	return ResourceSaver.save(Resource.new(), "%s.%s" % [save_path, _get_save_extension()])
