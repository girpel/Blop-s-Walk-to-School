extends AudioEffectFilter

@export var cutoff_hz_in := 2000
@export var tween_duration := 1.0

const CUTOFF_HZ_OUT := 20500

func tween_create(node: Node, property: NodePath, final_val: float) -> Tween:
	
	var tween = node.create_tween()
	tween.tween_property(self, property, final_val, tween_duration)
	
	return tween

func tween_in(node: Node) -> Tween:
	return tween_create(node, "cutoff_hz", cutoff_hz_in)

func tween_out(node: Node) -> Tween:
	return tween_create(node, "cutoff_hz", CUTOFF_HZ_OUT)

func _init() -> void:
	
	cutoff_hz = CUTOFF_HZ_OUT
	
	return
