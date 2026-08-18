class_name BallMoveState extends State

@export var movement_component: MovementComponent
@export var collision_component: CollisionComponent
@export var collision_state: State
@export var boundaries_collision_component: CollisionComponent
@export var boundaries_collision_state: BoundariesCollisionState
@export var brick_collision_component: CollisionComponent
@export var brick_collision_state: BrickCollisionState

func enter() -> void:
	collision_component.area_entered.connect(_on_area_entered)
	boundaries_collision_component.body_entered.connect(_on_boundary_body_entered)
	brick_collision_component.body_entered.connect(_on_brick_body_entered)

func exit() -> void:
	collision_component.area_entered.disconnect(_on_area_entered)
	boundaries_collision_component.body_entered.disconnect(_on_boundary_body_entered)
	brick_collision_component.body_entered.disconnect(_on_brick_body_entered)

func physics_update(_delta: float) -> void:
	movement_component.bounce()

func _on_area_entered(_area: Area2D) -> void:
	switch_state.emit(collision_state)

func _on_boundary_body_entered(_area: Node2D) -> void:
	switch_state.emit(boundaries_collision_state)

func _on_brick_body_entered(_body: Node2D) -> void:
	switch_state.emit(brick_collision_state)
