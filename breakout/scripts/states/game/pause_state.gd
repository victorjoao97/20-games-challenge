class_name PauseState extends State
@onready var input_component: InputComponent = %InputComponent
@onready var instructions: Label = %Instructions
@onready var health: Label = %Health

@export var playing_state: State

func enter() -> void:
	instructions.text = "Press ENTER to start"
	instructions.show()
	
func exit() -> void:
	instructions.hide()
	instructions.text = ""

func update(_delta) -> void:
	input_component.update()
	if input_component.enter_pressed:
		switch_state.emit(playing_state)
