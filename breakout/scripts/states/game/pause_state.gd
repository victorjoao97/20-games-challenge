class_name PauseState extends State
@onready var input_component: InputComponent = %InputComponent
@onready var instructions: Label = %Instructions
@onready var score_label: Label = %ScoreLabel

@export var generate_bricks: State

func enter() -> void:
	instructions.text = "Press ENTER to start"
	instructions.show()
	score_label.hide()
	
func exit() -> void:
	instructions.hide()

func update(_delta) -> void:
	input_component.update()
	if input_component.enter_pressed:
		switch_state.emit(generate_bricks)
