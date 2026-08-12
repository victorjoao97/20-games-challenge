extends Node2D
@onready var player_2: Player = $Player2
@onready var current_ball: Ball = $Ball

@export var difficult_ratio := 0.5
@export var next_level_thresold := 3
@export var max_levels := 10

signal ball_created(ball: Ball)

const BALL_SCENE := preload("res://scenes/ball.tscn")

var player1_score: int = 0
var player2_score: int = 0
var ball_initial_position: Vector2 = Vector2.ZERO
var current_level: float = 1.0
var current_ball_velocity: Vector2
var ai_level := 1.0

func _ready() -> void:
	MenuMusic.stop()
	GameState.start_game()
	print("Game mode: %s | Player mode: %s" % [GameState.level_mode, GameState.player_mode])
	player_2.playable = false if GameState.player_mode == GameState.PLAYER_MODE.SINGLEPLAYER else true
	ball_initial_position = current_ball.global_position
	current_ball_velocity = current_ball.linear_velocity
	ball_created.emit(current_ball)
	current_ball.hit_wall.connect(_on_hit_wall)
	update_level()
	update_score()

func update_dificulty(thresold: float):
	var difficulty = float(thresold - 1) / 9.0
	difficulty = pow(difficulty, 1.5)

	player_2.follow_speed = lerpf(
		100.0,
		player_2.SPEED,
		difficulty
	)

	player_2.error_interval = lerpf(
		1.5,
		0.15,
		difficulty
	)

	player_2.error_amount = lerpf(
		600,
		10.0,
		difficulty
	)

	print(
		"Level: %d | Velocidade: %.2f | Resposta: %.2f | Erro: %.2f"
		% [
			current_level,
			player_2.follow_speed,
			player_2.error_interval,
			player_2.error_amount
		]
	)

func show_credits():
	get_tree().change_scene_to_file("res://scenes/credits.tscn")

func update_level():
	if GameState.level_mode == GameState.LEVEL_MODE.LEVELS:
		EventHub.level_updated.emit(int(current_level))
		
		if current_level > max_levels:
			call_deferred("show_credits")
			return


	player1_score = 0
	player2_score = 0

	update_dificulty(current_level)

func update_score() -> void:
	EventHub.score_updated.emit(player1_score, player2_score)

func spawn_ball(body: Node) -> void:
	var new_ball: Ball = BALL_SCENE.instantiate()
	new_ball.global_position = ball_initial_position
	new_ball.linear_velocity = current_ball_velocity if body is LeftWall else Vector2(-current_ball_velocity.x, current_ball_velocity.y)
	add_child(new_ball)
	
	new_ball.hit_wall.connect(_on_hit_wall)
	ball_created.emit(new_ball)
	
	current_ball.queue_free()
	current_ball = new_ball
	

func _on_hit_wall(body: Node):
	if (body is LeftWall):
		player2_score += 1
	if (body is RightWall):
		player1_score += 1
		
	if (body is LeftWall or body is RightWall):
		print("Score P1: %d | P2: %d" % [player1_score, player2_score])
		EventHub.player_scored.emit()

		if GameState.level_mode == GameState.LEVEL_MODE.LEVELS:
			if player2_score >= next_level_thresold:
				player1_score = 0
				player2_score = 0
			if player1_score >= next_level_thresold:
				current_level += 1
				update_level()
		if GameState.player_mode == GameState.PLAYER_MODE.SINGLEPLAYER and GameState.level_mode == GameState.LEVEL_MODE.INFINITE:
			ai_level += 1
			update_dificulty(ai_level)
	
	call_deferred("spawn_ball", body)

	update_score()

func _exit_tree() -> void:
	GameState.finish_game()
