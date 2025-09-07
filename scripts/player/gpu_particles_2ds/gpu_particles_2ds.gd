extends Node2D

@onready var ground := $Ground
@onready var wall_jump := $WallJump
@onready var wall_slide := $WallSlide

@onready var water_move := $WaterMove
@onready var water_ground := $WaterGround
@onready var water_wall_jump := $WaterWallJump
@onready var water_wall_slide := $WaterWallSlide

@onready var _parent := get_parent()
@onready var _particles_flip := [ground, water_move, water_ground]

func particles_wall_side_set(particles: GPUParticles2DInstance) -> void:
	
	particles.scale.x = -_parent.wall_side
	particles.position.x = -abs(particles.position.x) * _parent.wall_side
	
	return

func _on_player_h_direction_changed(h_direction: int) -> void:
	
	for particle_flip in _particles_flip:
		particle_flip.position.x = abs(particle_flip.position.x) * h_direction
	
	return
