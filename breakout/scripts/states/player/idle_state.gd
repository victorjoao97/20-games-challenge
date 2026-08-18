class_name PlayerIdleState extends State

@export var input_component: InputComponent
@export var move_state: State

func update(_delta) -> void:
	if input_component.move_direction != Vector2.ZERO:
		switch_state.emit(move_state)
