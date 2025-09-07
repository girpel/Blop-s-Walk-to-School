extends Node

@export var shaders: Array[Shader]
@export var particle_process_materials: Array[ParticleProcessMaterial]

func shaders_preload() -> void:
	
	await get_tree().process_frame
	
	for shader in shaders:
		
		var color_rect := ColorRect.new()
		
		var shader_material := ShaderMaterial.new()
		shader_material.shader = shader
		
		color_rect.material = shader_material
		
		add_child(color_rect)
	
	for particle_process_material in particle_process_materials:
		
		var gpu_particles_2d := GPUParticles2D.new()
		gpu_particles_2d.process_material = particle_process_material
		
		add_child(gpu_particles_2d)
	
	await get_tree().process_frame
	
	for child in get_children():
		child.queue_free()
	
	process_mode = PROCESS_MODE_DISABLED
	
	return

func _process(_delta: float) -> void:
	
	shaders_preload()
	
	return
