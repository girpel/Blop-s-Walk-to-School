extends VBoxContainer

class_name VButtonsContainer

var v_buttons: Array[Node]

func focus() -> void:
	
	for v_button in v_buttons:
		
		if not v_button.disabled:
			
			v_button.button.grab_focus_skip()
			
			return
	
	return

func v_buttons_focus_neighbors_v_set() -> void:
	
	v_buttons = get_children()
	
	var v_buttons_size := v_buttons.size()
	var v_buttons_size_dec = v_buttons_size - 1
	
	for v_button_index in v_buttons_size:
		
		if v_button_index > 0:
			v_buttons[v_button_index].button.focus_neighbor_top = v_buttons[v_button_index - 1].button.get_path()
		
		if v_button_index < v_buttons_size_dec:
			v_buttons[v_button_index].button.focus_neighbor_bottom = v_buttons[v_button_index + 1].button.get_path()
	
	return

func _ready() -> void:
	
	v_buttons_focus_neighbors_v_set()
	
	return
