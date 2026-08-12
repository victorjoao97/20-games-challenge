extends Panel


func _ready() -> void:
	if !MenuMusic.playing:
		MenuMusic.play()


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu.tscn")


func _on_level_mode_pressed() -> void:
	GameState.set_level_mode(GameState.LEVEL_MODE.LEVELS)
	get_tree().change_scene_to_file("res://scenes/main.tscn")


func _on_infinite_mode_pressed() -> void:
	GameState.set_level_mode(GameState.LEVEL_MODE.INFINITE)
	get_tree().change_scene_to_file("res://scenes/main.tscn")
