extends VBoxContainer

@onready var v_buttons_focus_neighbor_right_self: Array[VButton] = [
	$Developers/Girpel, $Developers/Martin, $PotatoTesters/HBoxContainer/Kikivice, $Return
]

func v_buttons_focus_neighbor_right_self_set() -> void:
	
	for v_button in v_buttons_focus_neighbor_right_self:
		v_button.button.focus_neighbor_right = v_button.button.get_path()
	
	return

func _ready() -> void:
	
	v_buttons_focus_neighbor_right_self_set()
	
	return
