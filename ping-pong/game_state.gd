extends Node

enum LEVEL_MODE {
	LEVELS,
	INFINITE
}

enum PLAYER_MODE {
	SINGLEPLAYER,
	MULTIPLAYER
}

var game_started := false

var level_mode: LEVEL_MODE
var player_mode: PLAYER_MODE

func set_level_mode(mode: LEVEL_MODE):
	level_mode = mode

func set_player_mode(mode: PLAYER_MODE):
	player_mode = mode

func start_game():
	game_started = true
	
func finish_game():
	game_started = false
