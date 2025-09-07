extends Sprite2D

const RADIUS := 8
const OFFSET_LERP_WEIGHT := 0.15

var offset_lerp := offset

func offset_update() -> void:
	
	var position_difference := Globals.player.position - position
	offset_lerp = lerp(offset_lerp, position_difference.normalized() * min(RADIUS, position_difference.length()), OFFSET_LERP_WEIGHT)
	
	offset = offset_lerp.round()
	
	return

func _process(_delta: float) -> void:
	
	offset_update()
	
	return
