extends HBoxContainer

@export_node_path("HBoxContainer") var v_buttons_focus_neighbor_top_container_path: NodePath

func v_buttons_focus_neighbors_set() -> void:
	
	var v_box_containers := get_children()
	
	var v_box_containers_size := v_box_containers.size()
	var v_box_containers_size_dec := v_box_containers_size - 1
	
	var v_buttons_focus_neighbor_top := get_node(v_buttons_focus_neighbor_top_container_path).get_children()
	var v_buttons_focus_neighbor_top_size_dec := v_buttons_focus_neighbor_top.size() - 1
	
	for v_box_container_index in range(v_box_containers_size):
		
		var v_buttons := v_box_containers[v_box_container_index].get_children()
		v_buttons[0].button.focus_neighbor_top = v_buttons_focus_neighbor_top[min(v_box_container_index, v_buttons_focus_neighbor_top_size_dec)].button.get_path()
		
		for v_button_index in range(v_buttons.size()):
			
			if v_box_container_index > 0:
				v_buttons[v_button_index].button.focus_neighbor_left = v_box_containers[v_box_container_index - 1].get_child(v_button_index).button.get_path()
			
			if v_box_container_index < v_box_containers_size_dec:
				var v_button_focus_neighbor_right := v_box_containers[v_box_container_index + 1].get_child(v_button_index) if v_button_index < v_box_containers[v_box_container_index + 1].get_child_count() else v_buttons[v_button_index]
				v_buttons[v_button_index].button.focus_neighbor_right = v_button_focus_neighbor_right.button.get_path()
	
	return

func _ready() -> void:
	
	v_buttons_focus_neighbors_set()
	
	return
