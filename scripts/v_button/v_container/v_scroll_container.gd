extends Control

class_name VScrollContainer

const V_SCROLL_BAR_OFFSET := 8
const V_SCROLL_BAR_OFFSET_SIZE_Y_MULT := 4

const V_SCROLL_BAR_TWEEN_VALUE := 120
const V_SCROLL_BAR_TWEEN_DURATION := 0.18

const V_SCROLL_BAR_VALUE_DIV := 8

var v_scroll_bar := VScrollBar.new()

@onready var child := get_child(0)
@onready var child_position_y_initial: float = child.position.y

func v_scroll_bar_set() -> void:
	
	add_child(v_scroll_bar)
	
	v_scroll_bar.max_value = child.size.y
	v_scroll_bar.page = size.y - child_position_y_initial * 2
	v_scroll_bar.rounded = true
	
	v_scroll_bar.position = Vector2((size - v_scroll_bar.size).x - V_SCROLL_BAR_OFFSET, V_SCROLL_BAR_OFFSET)
	v_scroll_bar.size.y = size.y - V_SCROLL_BAR_OFFSET * V_SCROLL_BAR_OFFSET_SIZE_Y_MULT
	
	v_scroll_bar.value_changed.connect(_on_v_scroll_bar_value_changed)
	
	return

func v_buttons_set(node: Node) -> void:
	
	for node_child in node.get_children():
		
		if node_child is VButton:
			
			node_child.button.focus_entered.connect(_on_v_button_focus_entered.bind(node_child))
			
			continue
		
		v_buttons_set(node_child)
	
	return

func _ready() -> void:
	
	v_scroll_bar_set()
	v_buttons_set(child)
	
	return

func _gui_input(event: InputEvent) -> void:
	
	if event is InputEventMouseButton and event.pressed:
		v_scroll_bar.value += v_scroll_bar.page / V_SCROLL_BAR_VALUE_DIV * (int(event.is_action("ui_scroll_down")) - int(event.is_action("ui_scroll_up")))
	
	return

func _on_v_scroll_bar_value_changed(value: float) -> void:
	
	child.position.y = child_position_y_initial - value
	
	return

func _on_v_button_focus_entered(v_button: VButton) -> void:
	
	if v_button.button.focus_hovered:
		return
	
	var v_scroll_bar_value: float = (v_button.global_position - child.position).y - V_SCROLL_BAR_TWEEN_VALUE
	
	if (Globals.v_button_last_global_position_y - v_button.global_position.y) * (v_scroll_bar.value - v_scroll_bar_value) > 0:
		create_tween().tween_property(v_scroll_bar, "value", v_scroll_bar_value, V_SCROLL_BAR_TWEEN_DURATION).set_ease(Tween.EASE_IN_OUT)
	
	return
