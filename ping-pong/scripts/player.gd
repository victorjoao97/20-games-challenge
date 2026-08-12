extends StaticBody2D
class_name Player

@export var playable := true
@export var player_number: int
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

const SPEED = 300.0

var limit_y: Vector2

@export var follow_speed := 50.0
@export var error_interval := 0.3
@export var error_amount := 100.0
var target_y := 0.0
var error_timer := 0.0
var ball: Ball
var original_position: Vector2
var start_ai := false

func _ready() -> void:
	var shape = collision_shape.shape
	if (shape is RectangleShape2D):
		var shape_size = shape.size.y
		limit_y = Vector2(shape_size / 2, ProjectSettings.get_setting("display/window/size/viewport_height") - shape_size / 2)

	var main = get_parent()
	main.ball_created.connect(_on_main_ball_created)
	original_position = global_position
	
	EventHub.hit_player.connect(_on_hit_player)
	EventHub.player_scored.connect(_on_player_scored)

func _on_hit_player(_player: Player):
	start_ai = true

func _on_player_scored():
	start_ai = false

func _process(delta: float) -> void:
	if !playable and start_ai:
		_process_ai(delta)
		return

	var direction = Input.get_axis(
		"p%d-up" % player_number,
		"p%d-down" % player_number
	)

	var new_position_y = position.y + direction * SPEED * delta

	position.y = clampf(
		new_position_y,
		limit_y.x,
		limit_y.y
	)

func _process_ai(delta: float) -> void:
	if !is_instance_valid(ball):
		return

	error_timer -= delta

	if error_timer <= 0.0:
		error_timer = error_interval

		var ball_velocity = ball.linear_velocity
		var predicted_y = ball.global_position.y

		var ball_is_coming := false

		if player_number == 2:
			ball_is_coming = ball_velocity.x > 0.0
		else:
			ball_is_coming = ball_velocity.x < 0.0

		if ball_is_coming and abs(ball_velocity.x) > 0.01:
			var distance_x = abs(
				global_position.x - ball.global_position.x
			)

			var time_to_reach = distance_x / abs(ball_velocity.x)

			predicted_y += ball_velocity.y * time_to_reach
		else:
			predicted_y = (limit_y.x + limit_y.y) / 2.0

		target_y = clampf(
			predicted_y + randf_range(-error_amount, error_amount),
			limit_y.x,
			limit_y.y
		)

	# ------------------------------------------------------
	# 5. A IA não teleporta.
	#    Ela precisa chegar até o target.
	# ------------------------------------------------------

	position.y = move_toward(
		position.y,
		target_y,
		follow_speed * delta
	)

func _on_main_ball_created(new_ball: Ball) -> void:
	ball = new_ball
	global_position = original_position
