extends AudioEffectReverb

@export_range(0, 1) var dry_in := 1.0
@export_range(0, 1) var wet_in := 0.5

@export var tween_duration := 1.0

const DRY_OUT := 1
const WET_OUT := 0

func tween_create(node: Node, property: NodePath, final_val: float) -> Tween:
	
	var tween = node.create_tween()
	tween.tween_property(self, property, final_val, tween_duration)
	
	return tween

func tween_in(node: Node) -> Tween:
	tween_create(node, "dry", dry_in)
	return tween_create(node, "wet", wet_in)

func tween_out(node: Node) -> Tween:
	tween_create(node, "dry", DRY_OUT)
	return tween_create(node, "wet", WET_OUT)

func _init() -> void:
	
	dry = DRY_OUT
	wet = WET_OUT
	
	return
