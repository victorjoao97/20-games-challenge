extends Area2D


func _on_body_entered(body: Node2D) -> void:
	print("player collided in ground")
	if body.has_method("take_damage"):
		body.take_damage()
	if body.has_method("take_explode"):
		body.take_explode()
