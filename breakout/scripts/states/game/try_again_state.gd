class_name TryAgainState extends State
@onready var instructions: Label = %Instructions
@onready var ball: Ball = %Ball

@export var pause_state: State
@export var game_over_state: State

func enter() -> void:
	ball.die.connect(_on_die)
	instructions.text = "Try again"
	instructions.show()
	await get_tree().create_timer(2).timeout
	switch_state.emit(pause_state)

func exit() -> void:
	ball.die.disconnect(_on_die)
	instructions.text = ""
	instructions.hide()

func _on_die() -> void:
	switch_state.emit(game_over_state)
