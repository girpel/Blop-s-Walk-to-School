extends Label

@export var count_max_length := 0

func text_set(count: int) -> void:
	
	var count_current_string := str(count)
	var count_zero_string := ""
	
	for digit in count_max_length - count_current_string.length():
		count_zero_string += '0'
	
	text = "%s/%d" % [count_zero_string + count_current_string, Globals.coins_count_max]
	
	return

func coins_set(coin_count: int) -> void:
	
	Globals.coins_count = coin_count
	text_set(Globals.coins_count)
	
	return

func reset() -> void:
	
	coins_set(0)
	
	return

func _ready() -> void:
	
	count_max_length = str(Globals.coins_count_max).length()
	
	return

func _on_coins_tile_map_collected() -> void:
	
	coins_set(Globals.coins_count + 1)
	
	return
