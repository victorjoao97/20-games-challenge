class_name BrickDamageSttate extends State

@export var body: PhysicsBody2D

func enter() -> void:
	#queue_free.call_deferred()
	body.queue_free()
	pass
