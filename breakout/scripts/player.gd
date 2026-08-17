class_name Player extends CharacterBody2D
@onready var state_machine: StateMachine = $StateMachine
@onready var input_component: InputComponent = %InputComponent

func _physics_process(_delta: float) -> void:
	input_component.update()
