class_name BrickIdleState extends State
@onready var collision_component: CollisionComponent = %CollisionComponent

@export var damage_state: State

func enter() -> void:
	collision_component.body_entered.connect(_on_damage)

func exit() -> void:
	collision_component.body_entered.disconnect(_on_damage)

func _on_damage(_body: Node2D) -> void:
	switch_state.emit(damage_state)
