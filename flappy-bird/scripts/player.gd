class_name Player extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = %AnimatedSprite2D
@onready var impact_animation_sprite: AnimatedSprite2D = %ImpactAnimationSprite
@onready var smoke_animation_sprite: AnimatedSprite2D = %SmokeAnimationSprite

@export var debug := false
@export var floating := false
@export var speed = 220.0

var die := false
var dying_time := 0.0

const JUMP_VELOCITY = -250.0

signal player_scored
signal player_damaged

func _ready() -> void:
	animated_sprite_2d.play("fly")
	animated_sprite_2d.animation_finished.connect(_on_animation_finished)
	impact_animation_sprite.animation_finished.connect(_on_impact_animation_finished)

func _physics_process(delta: float) -> void:
	if die:
		if dying_time < 1.2:
			dying_time += delta
			animated_sprite_2d.rotation_degrees += -200 * delta
			velocity.y = -(1 * (speed))
			velocity.x += -5 * delta
			return

		var height = get_viewport_rect().size.y
		if global_position.y > height * 1.2:
			dying_time = 0.0
			process_mode = Node.PROCESS_MODE_DISABLED
			return

		animated_sprite_2d.rotation_degrees += -400 * delta
		velocity.x += -5 * delta
		velocity.y = 1 * (speed / 2)
		move_and_slide()

		return

	if floating:
		return

	if debug:
		var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		velocity = direction * speed

		move_and_slide()
		return
	
	animated_sprite_2d.play("fly")
	
	velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump"):
		velocity.y = JUMP_VELOCITY
		animated_sprite_2d.play("jump")

	velocity.x = 1 * speed

	move_and_slide()

func _on_animation_finished() -> void:
	#if animated_sprite_2d.animation == "death":
		#queue_free()
		#hide()
		#process_mode = Node.PROCESS_MODE_DISABLED
	pass

func _on_impact_animation_finished() -> void:
	impact_animation_sprite.hide()
	smoke_animation_sprite.show()
	smoke_animation_sprite.play("default")

func take_damage() -> void:
	velocity.x = 0
	floating = true
	die = true
	player_damaged.emit()
	animated_sprite_2d.play("death")
	impact_animation_sprite.show()
	impact_animation_sprite.play("default")
	set_collision_layer_value(2, false)
	set_collision_mask_value(1, false)

func increment_point() -> void:
	player_scored.emit()
