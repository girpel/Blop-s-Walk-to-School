extends State

class_name StatePlayer

enum States {STAND_IDLE, STAND_MOVE, CROUCH_IDLE, CROUCH_MOVE, JUMP, FALL, WALL_SLIDE_UP, WALL_SLIDE_DOWN, WALL_JUMP_SIDE, WALL_JUMP_UP, INTERACT, SIT, PHONE}

var h_direction_reset := 0
var h_deceleration_mult := 1.0
var v_speed_max_mult := 1.0
var v_speed_min_mult := 1.0
var h_accelerate := true
var rejump := true

@onready var player := owner
@onready var audio_stream_players := player.get_node("AudioStreamPlayers")
@onready var gpu_particles_2ds := player.get_node("GPUParticles2Ds")
@onready var timers := player.get_node("Timers")
