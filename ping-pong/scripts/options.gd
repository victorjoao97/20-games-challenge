extends Panel
@onready var back_to_menu: Button = $VBoxContainer/BackToMenu

func _on_master_slide_value_changed(value: float) -> void:
	var bus = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_linear(bus, value)


func _on_sfx_slide_value_changed(value: float) -> void:
	var bus = AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_volume_linear(bus, value)


func _on_music_slide_value_changed(value: float) -> void:
	var bus = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_volume_linear(bus, value)


func _on_fullscreen_button_toggled(toggled_on: bool) -> void:
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if toggled_on else DisplayServer.WINDOW_MODE_WINDOWED)


func _on_back_to_principal_pressed() -> void:
	hide()
	get_tree().paused = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		visible = !visible
		if (GameState.game_started):
			get_tree().paused = !get_tree().paused


func _on_draw() -> void:
	if !GameState.game_started:
		back_to_menu.hide()


func _on_back_to_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
