class_name BrickCollisionState extends State

@export var move_state: State

signal brick_damage

func enter() -> void:
	#print("touch a brick")
	brick_damage.emit()
	switch_state.emit(move_state)
