class_name NextLevelState extends State

@export var generate_bricks_state: State
@export var finish_state: State
@export var pause_state: State

@onready var instructions: Label = %Instructions
@onready var level_label: Label = %LevelLabel

@export var game_state: Game

var dialog := ConfirmationDialog.new()

func _ready() -> void:
	add_child(dialog)
	dialog.confirmed.connect(_on_next_level)
	dialog.canceled.connect(func() -> void: switch_state.emit(finish_state))

func _on_next_level() -> void:
	game_state.current_level += 1
	switch_state.emit(pause_state)

func exit() -> void:
	instructions.hide()

func enter() -> void:
	instructions.text = "You rock!"
	instructions.show()

	await get_tree().create_timer(2).timeout
	
	dialog.dialog_text = "Next level?"
	dialog.popup_centered()
	
	game_state.save_state()
