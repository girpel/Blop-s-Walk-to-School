extends AnimationTree

const ANIMATION_PLAYBACK_NODES: Array[String] = ["stand_idle", "stand_move", "crouch_idle", "crouch_move", "jump", "fall", "wall_slide_up", "wall_slide_down", "wall_jump_side", "wall_jump_up", "interact", "sit", "phone"]

const TIME_PATH := "parameters/{0}/time"
const ANIMATION_PLAYBACK_NODES_SYNC := {
	"stand_idle": ["crouch_idle", "interact"],
	"crouch_idle": ["stand_idle", "interact"],
	"interact": ["stand_idle", "crouch_idle"], 
	"stand_move": ["crouch_move"], 
	"crouch_move": ["stand_move"]}

const ANIMATIONS_LOOP_FIX := ["stand_idle", "crouch_idle", "interact", "phone"]
const STATE_MACHINE_TRANSITIONED_ADVANCE_COUNT := 3

var animation_playback: AnimationNodeStateMachinePlayback = get("parameters/playback")

var animation_loop_fix: String
var animation_loop_manual := false

@onready var animation_player := get_node(anim_player)

func animation_loop_fix_update() -> void:
	
	if animation_loop_manual:
		if animation_playback.get_current_play_position() == animation_playback.get_current_length():
			animation_playback.start(animation_loop_fix)
	
	return

func _process(_delta: float) -> void:
	
	animation_loop_fix_update()
	
	return

func _on_state_machine_transitioned(state: State) -> void:
	
	var animation_playback_node := animation_playback.get_current_node()
	
	animation_playback.travel(ANIMATION_PLAYBACK_NODES[state.state])
	
	for index in STATE_MACHINE_TRANSITIONED_ADVANCE_COUNT:
		advance(0)
	
	if animation_playback_node in ANIMATION_PLAYBACK_NODES_SYNC:
		if ANIMATION_PLAYBACK_NODES[state.state] in ANIMATION_PLAYBACK_NODES_SYNC[animation_playback_node]:
			set(TIME_PATH.format([ANIMATION_PLAYBACK_NODES[state.state]]), get(TIME_PATH.format([animation_playback_node])))
	
	animation_loop_manual = false
	
	if ANIMATION_PLAYBACK_NODES[state.state] in ANIMATIONS_LOOP_FIX:
		
		animation_loop_manual = true
		animation_loop_fix = ANIMATION_PLAYBACK_NODES[state.state]
	
	return
