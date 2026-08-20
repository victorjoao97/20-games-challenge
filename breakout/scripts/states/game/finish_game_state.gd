class_name FinishGameState extends State
@onready var instructions: Label = %Instructions

@export var game_state: Game

func enter() -> void:
	game_state.reset()

	instructions.text = "Thank you for playing!"
	instructions.show()

	await get_tree().create_timer(2).timeout
	
	get_tree().quit.call_deferred()
