class_name NextLevelState extends State

@export var generate_bricks_state: State
@export var finish_state: State

@onready var instructions: Label = %Instructions
@onready var level_label: Label = %LevelLabel

@export var game_state: Game

var dialog := ConfirmationDialog.new()

func _ready() -> void:
	add_child(dialog)
	dialog.confirmed.connect(_on_next_level)
	dialog.canceled.connect(func() -> void: switch_state.emit(finish_state))
	display_level()

func display_level() -> void:
	level_label.text = "Level: %d" % game_state.current_level

func _on_next_level() -> void:
	game_state.current_level += 1
	display_level()
	switch_state.emit(generate_bricks_state)

func exit() -> void:
	instructions.hide()

func enter() -> void:
	game_state.reset()

	instructions.text = "You rock!"
	instructions.show()

	await get_tree().create_timer(2).timeout
	
	dialog.dialog_text = "Next level?"
	dialog.popup_centered()
