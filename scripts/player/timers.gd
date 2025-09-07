extends Node

@onready var jump_just_buffer := $JumpJustBuffer
@onready var wall_jump_up_just_buffer := $WallJumpUpJustBuffer
@onready var v_jump := $VJump
@onready var h_jump := $HJump
@onready var wall_jump_up_delay := $WallJumpUpDelay
@onready var floor_buffer := $FloorBuffer
@onready var wall_buffer := $WallBuffer
@onready var land_audio_stream_pause := $LandAudioStreamPause
@onready var ground_particles_pause := $GroundParticlesPause
@onready var wall_slide_move_buffer := $WallSlideMoveBuffer
@onready var wall_slide_particles_delay := $WallSlideParticlesDelay
@onready var water_move_particles_delay := $WaterMoveParticlesDelay
@onready var sit := $Sit
