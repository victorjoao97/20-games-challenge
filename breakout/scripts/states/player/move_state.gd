class_name MoveState extends State

@export var input_component: InputComponent
@export var movement_component: MovementComponent
@export var idle_state: State

func update(_delta) -> void:
	var direction := input_component.move_direction

	if direction == Vector2.ZERO:
		switch_state.emit(idle_state)
		return

	movement_component.move(direction)
