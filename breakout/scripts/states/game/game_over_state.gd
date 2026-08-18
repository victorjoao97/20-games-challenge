class_name GameOverState extends State
@onready var instructions: Label = %Instructions

@export var game_state: Game

func enter() -> void:
	game_state.reset()

	instructions.text = "You lose"
	instructions.show()

	await get_tree().create_timer(2.0).timeout
	get_tree().reload_current_scene()
