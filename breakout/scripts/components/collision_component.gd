class_name CollisionComponent extends Node

signal area_entered(area: Area2D)
signal body_entered(body: Node2D)

@export var area: Area2D

func _ready() -> void:
	area.area_entered.connect(_on_area_entered)
	area.body_entered.connect(_on_body_entered)

func _on_area_entered(other: Area2D) -> void:
	area_entered.emit(other)

func _on_body_entered(other: Node2D) -> void:
	body_entered.emit(other)
