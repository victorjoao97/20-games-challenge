class_name BrickIdleState extends State
@onready var collision_component: CollisionComponent = %CollisionComponent
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var point_light_2d: PointLight2D = %PointLight2D

@export var damage_state: State

var is_damaged := false

func enter() -> void:
	animation_player.play("show")
	point_light_2d.enabled = false
	is_damaged = false
	collision_component.body_entered.connect(_on_damage)

func exit() -> void:
	collision_component.body_entered.disconnect(_on_damage)

func _on_damage(_body: Node2D) -> void:
	if is_damaged:
		return
	is_damaged = true
	switch_state.emit(damage_state)
