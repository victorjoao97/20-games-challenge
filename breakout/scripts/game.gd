class_name Game extends Node2D
@onready var health_component: HealthComponent = %HealthComponent
@onready var health_label: Label = %Health

@export var debug := false

signal level_changed(level: int)

var player_score := 0
var current_level := 1:
	set(value):
		current_level = value
		level_changed.emit(current_level)
	get:
		return current_level
var number_bricks := 0
var collected_bricks := 0
var record_score := 0

func _ready() -> void:
	_on_health_changed(health_component.health, health_component.max_health)
	health_component.health_changed.connect(_on_health_changed)
	current_level = 1
	record_score = 0
	load_state()

func increment_score() -> void:
	player_score += 1
	if player_score > record_score:
		record_score = player_score
	collected_bricks += 1

func reset() -> void:
	collected_bricks = 0

func _on_health_changed(health: float, _max_health: float) -> void:
	health_label.text = "Life: %d" % [health]
	health_label.show()

func save_state():
	var save_file = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	save_file.store_string(JSON.stringify({
		"current_level": current_level,
		"record_score": record_score,
	}))
	pass

func load_state():
	var save_file = FileAccess.open("user://savegame.save", FileAccess.READ)
	if !save_file:
		return
	var json = JSON.parse_string(save_file.get_as_text())
	current_level = json.current_level
	record_score = json.record_score
