class_name TryAgainState extends State
@onready var instructions: Label = %Instructions

@export var playing_state: State
@export var game_over_state: State
@export var health_component: HealthComponent

var died := false

func enter() -> void:
	died = false
	health_component.die.connect(_on_die)
	print("try again")
	health_component.take_damage(1.0)

	if died:
		return

	instructions.text = "Try again"
	instructions.show()
	await get_tree().create_timer(2).timeout
	
	if died:
		return

	switch_state.emit(playing_state)

func exit() -> void:
	instructions.hide()
	health_component.die.disconnect(_on_die)

func _on_die() -> void:
	died = true
	switch_state.emit(game_over_state)
