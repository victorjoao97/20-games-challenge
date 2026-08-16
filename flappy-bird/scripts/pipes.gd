class_name Pipes extends Node2D

@onready var pipe_1: Pipe = %Pipe1
@onready var pipe_2: Pipe = %Pipe2
@export var min_distance_top := 0.3
@export var min_distance_bottom := 0.01

@export_range(-1.0, 1.0) var gap_beetween := -1.0

func _ready() -> void:
	var viewport := get_viewport().get_visible_rect().size
	var height := viewport.y
	var center_y := height / 2.0
	
	var pipe_1_min_position_y = -center_y * (1 - min_distance_top)
	var pipe_1_max_position_y = 0.0 - height * min_distance_bottom 

	var pipe_1_new_position = randf_range(pipe_1_min_position_y, pipe_1_max_position_y)
	pipe_1.global_position.y = pipe_1_new_position

	var gap := remap(
		gap_beetween,
		-1.0,
		1.0,
		1.4, # gap máximo
		1.2  # gap mínimo
	)
	var min_gap := height * gap
	var max_pipe_y := height * 1.4

	var min_pipe_2_y := pipe_1.global_position.y + min_gap

	if min_pipe_2_y > max_pipe_y:
		min_pipe_2_y = max_pipe_y

	pipe_2.global_position.y = min_pipe_2_y
	#pipe_2.global_position.y = randf_range(
		#min_pipe_2_y,
		#max_pipe_y
	#)

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
	print("pipe removed from the screen")


func _on_checkpoint_body_entered(body: Node2D) -> void:
	print("player collided in Checkpoint")
	if body.has_method("increment_point"):
		body.increment_point()
