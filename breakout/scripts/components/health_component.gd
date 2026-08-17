class_name HealthComponent extends Node

@export var max_health := 100.0

signal die
signal health_changed(health: float, max_health: float)

var health := 0.0

func _ready() -> void:
	health = max_health
	health_changed.emit(health, max_health)

func _physics_process(delta: float) -> void:
	health_changed.emit(health, max_health)

func take_damage(amount: float) -> void:
	health = clampf(health - amount, 0.0, max_health)

	if health == 0.0:
		die.emit()

	health_changed.emit(health, max_health)
