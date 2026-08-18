class_name CollisionState extends State

@export var move_state: State

signal collision

func enter() -> void:
	collision.emit()
