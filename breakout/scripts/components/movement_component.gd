class_name MovementComponent extends Node

@export var body: CharacterBody2D
@export var model: Node2D
@export var speed := 8.0
@export var jump_velocity := 12.0
@export var gravity_multiplier := 3.0

func move(direction: Vector2) -> void:
	if !body:
		return
	
	body.velocity.x = direction.x * speed
	body.move_and_slide()

func bounce() -> void:
	var collision := body.move_and_collide(
		body.velocity * get_physics_process_delta_time()
	)

	if collision:
		body.velocity = body.velocity.bounce(collision.get_normal())
