extends Node2D

@onready var player: Player = %Player
@onready var camera_2d: Camera2D = %Camera2D
@onready var record_label: Label = %RecordLabel
@onready var center_line_debug: Line2D = %CenterLineDebug
@onready var enter_to_start: Label = %EnterToStart
@onready var parallax_backgrounds: Node2D = %Parallaxes
@onready var ended_panel: Panel = $CanvasLayer/Control/EndedPanel
@onready var ended_record_label: Label = %EndedRecordLabel
@onready var reload_button: Button = %ReloadButton
@onready var audio_stream_player: AudioStreamPlayer = %AudioStreamPlayer
@onready var ended_last_record_label: Label = %EndedLastRecordLabel
@onready var background_music: AudioStreamPlayer = %BackgroundMusic
@onready var mute_button: Button = %MuteButton

@export var debug := false
@export var disable_camera := false
@export var distance_min := 200
@export var distance_max := 400
@export var started_from_x := 200
@export var create_pipes := true

const pipe: PackedScene = preload("uid://d3uac7wjorfa8")
var last_pipe_x: float
var record := 0
var gap_between := -1.0
var game_started := false

var player_scored_stream = preload("uid://dnfmvatensikc")
var player_damage_stream = preload("uid://c2k6d77lptus0")
var game_started_stream = preload("uid://bu6vuco1ycey2")

func _ready() -> void:
	setup()
	
	if disable_camera:
		camera_2d.limit_top = -1000000
		camera_2d.limit_bottom = int(get_viewport().get_visible_rect().size.y)
	
	player.player_scored.connect(_on_player_scored)
	player.player_damaged.connect(_on_player_damage)
	
func _process(_delta: float) -> void:
	if !game_started:
		for parallax in parallax_backgrounds.get_children() as Array[Parallax2D]:
			parallax.autoscroll.x = -200.0 * parallax.scroll_scale.x

func setup() -> void:
	ended_panel.hide()
	player.floating = true
	last_pipe_x = get_viewport_rect().size.x * 1.5

	handle_debug()
	change_score_label()
	
	var tween := create_tween()
	tween.tween_property(background_music, "volume_linear", 1.0, 6.0)
	
func create_first_pipes(number: int) -> void:
	if create_pipes:
		for i in range(number):
			create_pipe(last_pipe_x)
			last_pipe_x += randf_range(distance_min, distance_max)

func handle_debug() -> void:
	player.debug = debug
	center_line_debug.visible = debug
	reload_button.visible = debug

func change_score_label() -> void:
	record_label.text = "Record: " + str(record)
	if debug:
		record_label.text += "\n" + "GAP: " + str(gap_between)

	ended_record_label.text = str(record)

func _on_player_scored() -> void:
	play_player_scored()
	record += 1
	
	if fmod(record, 10) == 0:
		gap_between += 0.5
	print("gap ", gap_between)
	
	change_score_label()

func play_player_scored() -> void:
	audio_stream_player.stream = player_scored_stream
	audio_stream_player.volume_linear = 0.7
	audio_stream_player.play()

func play_player_damage() -> void:
	audio_stream_player.stream = player_damage_stream
	audio_stream_player.volume_linear = 1.5
	audio_stream_player.play()

func _on_player_damage() -> void:
	play_player_damage()
	ended_last_record_label.text = str(GameState.last_score)
	if record > GameState.last_score:
		GameState.last_score = record
	ended_panel.show()

func _on_child_exiting_tree(node: Node) -> void:
	if !node.is_in_group("pipes"):
		return

	last_pipe_x += randf_range(distance_min, distance_max)
	call_deferred("create_pipe", last_pipe_x)

func create_pipe(x_position: float) -> void:
	var new_pipe = pipe.instantiate() as Pipes
	new_pipe.global_position.x = x_position
	new_pipe.add_to_group("pipes")
	new_pipe.gap_beetween = gap_between
	add_child(new_pipe)

func reload() -> void:
	get_tree().reload_current_scene()

func _on_button_pressed() -> void:
	print("reload")
	call_deferred("reload")
	
func start_game() -> void:
	while enter_to_start.text.length() > 0:
		enter_to_start.text = enter_to_start.text.left(enter_to_start.text.length() - 1)
		await get_tree().create_timer(0.1).timeout

	create_first_pipes(5)
	player.floating = false
	game_started = true

	for parallax in parallax_backgrounds.get_children() as Array[Parallax2D]:
		parallax.autoscroll.x = 0
	
	mute_button.release_focus()

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		start_game()
		return

	if event.is_action_pressed("ui_cancel"):
		call_deferred("quit")

func quit():
	get_tree().quit()

func _on_try_again_button_pressed() -> void:
	call_deferred("reload")

func _on_quit_button_pressed() -> void:
	call_deferred("quit")

func _on_mute_button_pressed() -> void:
	var audio_bus := AudioServer.get_bus_index("Master")
	var volume := 1
	if mute_button.text == "Mute":
		mute_button.text = "Unmute"
		volume = 0
	else:
		mute_button.text = "Mute"
		volume = 1

	AudioServer.set_bus_volume_linear(audio_bus, volume)
