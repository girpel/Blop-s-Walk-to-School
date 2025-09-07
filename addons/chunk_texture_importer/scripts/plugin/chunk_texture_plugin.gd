@tool
extends EditorPlugin

var editor_file_system := get_editor_interface().get_resource_filesystem()

var ChunkTextureImport := preload("../import/chunk_texture_import.gd")
var chunk_texture_import

func chunk_texture_import_add() -> void:
	
	chunk_texture_import = ChunkTextureImport.new()
	chunk_texture_import.editor_file_system = editor_file_system
	
	add_import_plugin(chunk_texture_import)
	
	return

func chunk_texture_import_remove() -> void:
	
	remove_import_plugin(chunk_texture_import)
	chunk_texture_import = null
	
	return

func _enter_tree() -> void:
	
	chunk_texture_import_add()
	
	return

func _exit_tree() -> void:
	
	chunk_texture_import_remove()
	
	return
