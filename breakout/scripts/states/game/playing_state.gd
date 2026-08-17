class_name PlayingState extends State
@onready var ball: Ball = %Ball
@onready var health_label: Label = %Health

@export var try_again_state: State

var original_ball_position: Vector2

func _ready() -> void:
	original_ball_position = ball.global_position

func enter() -> void:
	ball.collision.connect(_on_collision)
	ball.health_changed.connect(_on_health_changed)
	ball.global_position = original_ball_position
	ball.start()

func exit() -> void:
	ball.collision.disconnect(_on_collision)
	ball.health_changed.disconnect(_on_health_changed)

func _on_collision() -> void:
	switch_state.emit(try_again_state)

func _on_health_changed(health: float, max_health: float) -> void:
	health_label.text = "%d / %d <3" % [health, max_health]
	health_label.show()
