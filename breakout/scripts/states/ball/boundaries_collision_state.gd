class_name BoundariesCollisionState extends State
@onready var sprite_2d: Sprite2D = %Sprite2D

@export var collision_state: State
@export var move_state: State
var alternativa_texture = preload("uid://bs2pfa3uujuj7")
var original_texture: Texture2D
var original_scale: Vector2

func _ready() -> void:
	original_texture = sprite_2d.texture
	original_scale = sprite_2d.scale

func enter() -> void:
	#print("play some sound on hit boundary")
	#sprite_2d.texture = alternativa_texture
	pass

func exit() -> void:
	#var tween = create_tween()
	#tween.tween_property(sprite_2d, "scale", Vector2(1, 1), 0.1)
	#await get_tree().create_timer(0.2).timeout
	#sprite_2d.texture = original_texture
	#sprite_2d.scale = original_scale
	pass

func update(_delta) -> void:
	switch_state.emit(move_state)
