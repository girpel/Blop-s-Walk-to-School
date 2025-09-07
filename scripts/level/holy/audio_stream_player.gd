extends AudioStreamPlayer

const START_TWEEN_DURATION := 24
const END_TWEEN_DURATION := 5

var start_tweens: Array[Tween] = []

func volume_db_tween_create(final_val: float, duration: float) -> Tween:
	
	var volume_db_tween := create_tween()
	volume_db_tween.tween_property(self, "volume_db", final_val, duration)
	
	return volume_db_tween

func ambience_default_volume_db_set(ambinece_default_volume_db: float) -> void:
	
	AudioServer.set_bus_volume_db(Globals.AudioBuses.AMBIENCE_DEFAULT, ambinece_default_volume_db)
	
	return

func ambience_default_volume_db_tween_create(final_val: float, duration: float) -> Tween:
	
	var ambience_default_volume_db_tween := create_tween()
	ambience_default_volume_db_tween.tween_method(ambience_default_volume_db_set, AudioServer.get_bus_volume_db(Globals.AudioBuses.AMBIENCE_DEFAULT), final_val, duration)
	
	return ambience_default_volume_db_tween

func _init() -> void:
	
	volume_db = Globals.VOLUME_DB_MIN
	
	return

func _on_holy_start() -> void:
	
	play(randf_range(0, stream.get_length()))
	
	start_tweens.append(volume_db_tween_create(0, START_TWEEN_DURATION))
	start_tweens.append(ambience_default_volume_db_tween_create(Globals.VOLUME_DB_MIN, START_TWEEN_DURATION))
	
	return

func _on_holy_end() -> void:
	
	for start_tween in start_tweens:
		start_tween.kill()
	
	start_tweens.clear()
	
	volume_db_tween_create(Globals.VOLUME_DB_MIN, END_TWEEN_DURATION).finished.connect(stop)
	ambience_default_volume_db_tween_create(0, END_TWEEN_DURATION)
	
	return
