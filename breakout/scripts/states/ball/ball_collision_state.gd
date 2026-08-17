class_name CollisionState extends State
@onready var health_component: HealthComponent = %HealthComponent

@export var move_state: State
@export var die_state: State

signal collision

func exit() -> void:
	health_component.die.disconnect(_on_die)

func enter() -> void:
	health_component.die.connect(_on_die)
	collision.emit()
	health_component.take_damage(1.0)

func _on_die() -> void:
	switch_state.emit(die_state)
