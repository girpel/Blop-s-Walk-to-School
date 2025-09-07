extends Node

enum CollisionLayers {PLAYER = 1, SOLIDS_REGULAR = 2, SOLIDS_ONE_WAY = 4, RIGID_BODY = 8, COINS = 16}
enum TilesSize {SOLIDS_REGULAR = 8, SOLIDS_ONE_WAY = 8, COINS = 8}
enum AudioBuses {MASTER, UI, WATER, SOUND_EFFECTS, AMBIENCE, AMBIENCE_DEFAULT, AMBIENCE_OUTSIDE, AMBIENCE_INSIDE}

const VOLUME_DB_MAX := 0
const VOLUME_DB_MIN := -60

const SOLIDS_COLLISION_MASK := CollisionLayers.SOLIDS_REGULAR + CollisionLayers.SOLIDS_ONE_WAY
const VIEWPORT_SIZE := Vector2(512, 288)
const VIEWPORT_SIZE_HALF := VIEWPORT_SIZE / 2

const FRIEND_PITCH_SCALE := 1

var web_export: bool

var v_button_pressed_last: VButton
var v_button_last_global_position_y := 0.0

var inputs_textures := [{}, {}]

var player: CharacterBody2D

var cutscene_ended := false
var ending := false

var coins_count := 0
var coins_count_max := 0
