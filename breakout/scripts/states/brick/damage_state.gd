class_name BrickDamageSttate extends State

@export var body: PhysicsBody2D
@export var collision_area: Area2D
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var point_light_2d: PointLight2D = %PointLight2D

func enter() -> void:
	point_light_2d.enabled = true
	var tween = create_tween()
	tween.tween_property(point_light_2d, "texture_scale", 0, 1)
	body.set_collision_layer_value(5, false)
	body.set_collision_mask_value(5, false)
	collision_area.set_deferred("monitoring",  false)
	collision_area.set_deferred("monitorable", false)
	animation_player.play("hide")
	await animation_player.animation_finished
	
	body.queue_free.call_deferred()
