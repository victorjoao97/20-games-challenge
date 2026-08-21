extends Label

func _on_game_level_changed(level: int) -> void:
	text = "Level: %d" % level
