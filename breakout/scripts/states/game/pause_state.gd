class_name PauseState extends State
@onready var input_component: InputComponent = %InputComponent
@onready var instructions: Label = %Instructions
@onready var score_label: Label = %ScoreLabel
@onready var player: Player = %Player
@onready var ball: Ball = %Ball

@export var generate_bricks: State

var tween: Tween

func enter() -> void:
	ball.hide()
	tween = create_tween()
	
	tween.set_loops()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	var distancia := 100.0
	var tempo := 2
	tween.tween_property(player, "position:x", player.position.x - distancia, tempo)
	tween.tween_property(player, "position:x", player.position.x + distancia, tempo)

	instructions.text = "Press ENTER to start"
	instructions.show()
	score_label.hide()
	
func exit() -> void:
	tween.stop()
	instructions.hide()

func update(_delta) -> void:
	input_component.update()
	if input_component.enter_pressed:
		switch_state.emit(generate_bricks)
