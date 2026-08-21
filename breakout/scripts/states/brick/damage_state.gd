class_name BrickDamageSttate extends State

@export var body: PhysicsBody2D
@export var collision_area: Area2D
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var point_light_2d: PointLight2D = %PointLight2D

func enter() -> void:
	point_light_2d.texture_scale = 0
	point_light_2d.enabled = true
	var tween = create_tween()
	tween.tween_property(point_light_2d, "texture_scale", 1, 1)
	#point_light_2d.energy = lerpf(0, 1, 0.01)
	body.set_collision_layer_value(5, false)
	body.set_collision_mask_value(5, false)
	collision_area.set_deferred("monitoring",  false)
	collision_area.set_deferred("monitorable", false)
	#body.queue_free()
	animation_player.play("hide")
	await animation_player.animation_finished
	
	var tween2 = create_tween()
	tween2.tween_property(point_light_2d, "texture_scale", 0, 0.5)
	body.queue_free.call_deferred()
