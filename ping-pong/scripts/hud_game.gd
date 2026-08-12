extends Control
@onready var nivel_label: Label = $NivelLabel
@onready var score_player_1: Label = $HBoxContainer/ScorePlayer1
@onready var score_player_2: Label = $HBoxContainer/ScorePlayer2

func _ready() -> void:
	EventHub.level_updated.connect(_on_level_updated)
	EventHub.score_updated.connect(_on_score_updated)
	
	if GameState.level_mode != GameState.LEVEL_MODE.LEVELS:
		nivel_label.hide()

func _on_level_updated(new_level: int):
	nivel_label.text = "Level " + str(new_level)

func _on_score_updated(player_1: int, player_2: int):
	if GameState.player_mode == GameState.PLAYER_MODE.SINGLEPLAYER:
		score_player_2.text = "CPU " + str(player_2)
	else:
		score_player_2.text = "P2 " + str(player_2)
	score_player_1.text = "P1 " + str(player_1)
