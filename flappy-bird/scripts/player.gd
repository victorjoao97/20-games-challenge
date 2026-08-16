class_name Player extends CharacterBody2D

@export var debug := false
@export var floating := false

const SPEED = 250.0
const JUMP_VELOCITY = -300.0

signal player_scored
signal player_damaged

func _physics_process(delta: float) -> void:
	if floating:
		return

	if debug:
		var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		velocity = direction * SPEED

		move_and_slide()
		return
	
	velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump"):
		velocity.y = JUMP_VELOCITY

	velocity.x = 1 * SPEED

	move_and_slide()

func take_damage() -> void:
	floating = true
	player_damaged.emit()
	process_mode = Node.PROCESS_MODE_DISABLED

func increment_point() -> void:
	player_scored.emit()
