extends Control
@onready var scroll_container: ScrollContainer = $Principal/ScrollContainer
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var close: Button = %Close

@export var scroll_speed := 80.0
@export var start_delay := 1.5

var timer := 0.0
var started := false
var stop := false

func _ready() -> void:
	MenuMusic.stop()
	close.hide()
	get_tree().create_timer(10).timeout.connect(func (): close.show())

func _process(delta: float) -> void:
	if stop:
		return

	if !started:
		timer += delta

		if timer >= start_delay:
			started = true
			audio_stream_player.play()

		return

	scroll_container.set_deferred("scroll_vertical", scroll_container.scroll_vertical + scroll_speed * delta)


func _on_close_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
