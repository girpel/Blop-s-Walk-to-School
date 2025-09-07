extends TextureRect

signal texture_changed
signal texture_ready

var input_index = 0

func texture_update() -> void:
	
	if texture != Globals.inputs_textures[Inputs.input_type][owner.action]:
		
		var texture_null = texture == null
		
		texture = Globals.inputs_textures[Inputs.input_type][owner.action]
		owner.reset_size()
		
		texture_ready.emit() if texture_null else texture_changed.emit()
	
	return

func _process(_delta: float) -> void:
	
	texture_update()
	
	return
