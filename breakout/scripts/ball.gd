class_name Ball extends CharacterBody2D
@onready var state_machine: StateMachine = %StateMachine
@onready var collision_state: CollisionState = %CollisionState
@onready var move_state: BallMoveState = $StateMachine/MoveState
@onready var brick_collision_state: BrickCollisionState = %BrickCollisionState

@onready var movement_component: MovementComponent = %MovementComponent

signal collision
signal brick_collected

func _ready() -> void:
	collision_state.collision.connect(collision.emit)
	brick_collision_state.brick_damage.connect(brick_collected.emit)

func start(_velocity: float) -> void:
	movement_component.bounce_speed = _velocity
	state_machine.change_state(move_state)

func change_velocity(_velocity: float) -> void:
	movement_component.bounce_speed = _velocity

func _physics_process(_delta: float) -> void:
	movement_component.bounce_direction = enforce_min_angle(movement_component.bounce_direction, deg_to_rad(15.0))

func stop() -> void:
	movement_component.stop()

func enforce_min_angle(dir: Vector2, min_angle: float) -> Vector2:
	var angle = dir.angle()

	# Normaliza o ângulo para -PI ... PI
	angle = wrapf(angle, -PI, PI)

	# Evita movimento quase horizontal
	if abs(sin(angle)) < sin(min_angle):
		var y_sign = sign(sin(angle))

		if y_sign == 0:
			y_sign = 1

		angle = y_sign * min_angle

		if cos(angle) < 0:
			angle = PI - angle

	return Vector2.from_angle(angle).normalized()
