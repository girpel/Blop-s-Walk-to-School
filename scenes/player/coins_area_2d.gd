extends Area2D

var body_current: Node2D

func _on_body_shape_entered(body_rid: RID, body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	
	body._on_collect(body_rid)
	
	return
