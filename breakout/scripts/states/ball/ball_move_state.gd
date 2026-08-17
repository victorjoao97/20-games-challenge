class_name BallMoveState extends State
@onready var health_component: HealthComponent = %HealthComponent

@export var movement_component: MovementComponent
@export var collision_component: CollisionComponent
@export var collision_state: State
@export var boundaries_collision_component: CollisionComponent
@export var boundaries_collision_state: BoundariesCollisionState

signal health_changed(health: float, max_health: float)

func enter() -> void:
	collision_component.area_entered.connect(_on_area_entered)
	boundaries_collision_component.body_entered.connect(_on_boundary_body_entered)
	health_component.health_changed.connect(health_changed.emit)

func exit() -> void:
	collision_component.area_entered.disconnect(_on_area_entered)
	boundaries_collision_component.body_entered.disconnect(_on_boundary_body_entered)
	health_component.health_changed.disconnect(health_changed.emit)

func update(_delta: float) -> void:
	movement_component.bounce()

func _on_area_entered(_area: Area2D) -> void:
	switch_state.emit(collision_state)

func _on_boundary_body_entered(_area: Node2D) -> void:
	switch_state.emit(boundaries_collision_state)
