class_name Pipe extends Area2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

func _on_body_entered(body: Node2D) -> void:
	print("player collided in area2d")
	if body.has_method("take_damage"):
		body.take_damage()
