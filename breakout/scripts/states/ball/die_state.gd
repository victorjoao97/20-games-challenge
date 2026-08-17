class_name BallDieState extends State

signal die

func enter() -> void:
	die.emit()
