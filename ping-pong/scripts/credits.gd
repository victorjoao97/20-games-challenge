extends Control
@onready var scroll_container: ScrollContainer = $Principal/ScrollContainer

@export var scroll_speed := 80.0
@export var start_delay := 1.5

var timer := 0.0
var started := false
var stop := false

func _process(delta: float) -> void:
	if stop:
		return

	if !started:
		timer += delta

		if timer >= start_delay:
			started = true

		return

	var before = scroll_container.scroll_vertical
	scroll_container.scroll_vertical += scroll_speed * delta
	
	if before >= scroll_container.scroll_vertical:
		stop = true
		get_tree().change_scene_to_file("res://scenes/menu.tscn")
