extends ColorRect

func _init() -> void:
	
	Options.color_palette_changed.connect(_on_options_color_palette_changed)
	
	return

func _on_options_color_palette_changed(colors: Array):
	
	for color_index in colors.size():
		material.set_shader_parameter("color_%s" % color_index, colors[color_index])
	
	return
