class_name PlayingState extends State
@onready var ball: Ball = %Ball
@onready var player: Player = %Player
@onready var score_label: Label = %ScoreLabel

@export var try_again_state: State
@export var game_over_state: State
@export var next_level: State
@export var game_state: Game

const BALL_SPEED := 400

var original_ball_position: Vector2
var original_player_position: Vector2

var a := 0
var multiplier_per_point := 0.016
var max_multiplier := 2.0

func _ready() -> void:
	original_ball_position = ball.global_position
	original_player_position = player.global_position

func enter() -> void:
	ball.collision.connect(_on_collision)
	ball.brick_collected.connect(_on_brick_collected)
	player.global_position = original_player_position
	ball.global_position = original_ball_position
	ball.start(BALL_SPEED)
	display_score()

func exit() -> void:
	ball.stop()
	ball.collision.disconnect(_on_collision)
	ball.brick_collected.disconnect(_on_brick_collected)

func _on_collision() -> void:
	a = 0
	switch_state.emit(try_again_state)

func _on_brick_collected() -> void:
	a += 1
	game_state.increment_score()
	display_score()

	if game_state.player_score >= game_state.number_bricks:
		switch_state.emit(next_level)
		return

	ball.change_velocity(get_ball_speed())

func display_score() -> void:
	score_label.text = "Score: %d" % [game_state.player_score]
	score_label.show()

func get_ball_speed() -> float:
	var multiplier: float = min(1.0 + a * multiplier_per_point, max_multiplier)
	return BALL_SPEED * multiplier
