class_name InputComponent extends Node

var move_direction := Vector2.ZERO
var enter_pressed := false

func update() -> void:
	move_direction = Input.get_vector("move_left", "move_right", "ui_up", "ui_down")

	enter_pressed = Input.is_action_just_pressed("enter")
