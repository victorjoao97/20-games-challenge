extends Control
@onready var options: Panel = $Options

func _ready() -> void:
	if !MenuMusic.playing:
		MenuMusic.play()

func _on_one_player_pressed() -> void:
	GameState.set_player_mode(GameState.PLAYER_MODE.SINGLEPLAYER)
	show_modes()

func show_modes():
	get_tree().change_scene_to_file("res://scenes/menu-modes.tscn")
	

func show_options():
	options.show()

func _on_one_player_2_pressed() -> void:
	GameState.set_player_mode(GameState.PLAYER_MODE.MULTIPLAYER)
	show_modes()

func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_options_pressed() -> void:
	show_options()
