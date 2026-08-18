class_name MovementComponent extends Node

@export var body: CharacterBody2D
@export var model: Node2D
@export var speed := 400.0
@export var bounce_speed := 400.0
@export var jump_velocity := 12.0
@export var gravity_multiplier := 3.0

var bounce_direction := Vector2(1, -1).normalized()

func move(direction: Vector2) -> void:
	if !body:
		return
	
	body.velocity.x = direction.x * speed
	body.move_and_slide()

func bounce() -> void:
	var collision = body.move_and_collide(bounce_direction * bounce_speed * get_physics_process_delta_time())

	if collision:
		bounce_direction = bounce_direction.bounce(collision.get_normal()).normalized()

func stop() -> void:
	bounce_speed = 0
