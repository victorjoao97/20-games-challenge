extends RigidBody2D
class_name Ball

@onready var sfx_top_down: AudioStreamPlayer2D = $"../SFXTopDown"
@onready var sfx_points: AudioStreamPlayer2D = $"../SFXPoints"
@onready var sfx_player: AudioStreamPlayer2D = $"../SFXPlayer"

signal hit_wall(body)

var audio_streams: Array[AudioStream]

func _ready() -> void:
	audio_streams.append_array([
		preload("uid://rqoklqiqit2i"),
		preload("uid://bmhpbys45v8tt")
	])

func _on_body_entered(body: Node) -> void:
	if (body is RightWall or body is LeftWall):
		hit_wall.emit(body)
		sfx_top_down.pitch_scale = clampf(randf_range(0.8, 1.2), 0.8, 1.2)
		sfx_points.play()
	if (body is Player):
		sfx_player.play()
		EventHub.emit_hit_player(body)

	if body.name == "WallsTopDown":
		sfx_top_down.stream = audio_streams.pick_random()
		sfx_top_down.pitch_scale = clampf(randf_range(0.5, 1.5), 0.5, 1.5)
		sfx_top_down.play()
