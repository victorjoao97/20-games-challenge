class_name Ball extends CharacterBody2D
@onready var state_machine: StateMachine = %StateMachine
@onready var collision_state: CollisionState = %CollisionState
@onready var move_state: BallMoveState = $StateMachine/MoveState
@onready var die_state: BallDieState = %DieState

signal collision
signal die
signal health_changed(health: float, max_health: float)

func _ready() -> void:
	collision_state.collision.connect(_on_collision)
	die_state.die.connect(_on_die)
	move_state.health_changed.connect(health_changed.emit)

func start() -> void:
	velocity = Vector2(150, -400)
	state_machine.change_state(move_state)

func _on_collision() -> void:
	collision.emit()

func _on_die() -> void:
	die.emit()
