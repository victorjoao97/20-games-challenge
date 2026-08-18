class_name Game extends Node2D
@onready var health_component: HealthComponent = %HealthComponent
@onready var health_label: Label = %Health

@export var debug := false
var player_score := 0
var current_level := 1
var number_bricks: int

func _ready() -> void:
	_on_health_changed(health_component.health, health_component.max_health)
	health_component.health_changed.connect(_on_health_changed)

func increment_score() -> void:
	player_score += 1

func reset() -> void:
	player_score = 0

func _on_health_changed(health: float, _max_health: float) -> void:
	health_label.text = "Life: %d" % [health]
	health_label.show()
