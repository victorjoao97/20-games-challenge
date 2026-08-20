class_name BrickGenerator extends Node
@onready var line_edit: LineEdit = $LineEdit
@onready var label: Label = $Label
@onready var button: Button = $Button

@export var limit: Vector2
@export var end: Vector2
@export var scene: PackedScene
@export var debug := false
@export var noise := 0.3
@export var frequency := 0.08
@export var seed_number := 1

var noise_instance := FastNoiseLite.new()
var total_children := 0
var assets: Array[int]

signal children_created(total: int)

func _ready():
	line_edit.visible = debug
	label.visible = debug
	button.visible = debug
	
	#assets = load_sprites_from_folder("res://assets/kenney_rollingBallAssets/PNG/Default/")

func generate() -> void:
	noise_instance.seed = randi() if !seed_number else seed_number
	noise_instance.frequency = frequency
	
	var brick: Node2D = scene.instantiate()
	var brick_bounds := get_bounds(brick)
	
	remove_bricks()
	total_children = 0

	for x in range(limit.x, end.x, brick_bounds.size.x):
		for y in range(limit.y, end.y, brick_bounds.size.y):
			var noise_value = noise_instance.get_noise_2d(x, y)

			if noise_value > noise:
				var new_brick: Node2D = scene.instantiate()
				new_brick.position = Vector2(x, y)
				new_brick.add_to_group("bricks")
				#var sprite: Sprite2D = new_brick.get_node("Sprite2D")
				#sprite.texture = load(ResourceUID.id_to_text(assets.pick_random()))
				add_child(new_brick)
				total_children += 1
	children_created.emit(total_children)
	print("Total childrens ", total_children)

func _input(event: InputEvent) -> void:
	if debug and event.is_action_pressed("enter"):
		get_tree().reload_current_scene()
		_ready()

func get_bounds(node: Node2D) -> Rect2:
	var rect = Rect2()
	var first = true

	for child in node.get_children():
		if child is Sprite2D and child.texture:
			var sprite_rect = Rect2(
				child.global_position - child.texture.get_size() * child.scale / 2.0,
				child.texture.get_size() * child.scale
			)

			if first:
				rect = sprite_rect
				first = false
			else:
				rect = rect.merge(sprite_rect)

	return rect

func remove_bricks() -> void:
	for child in get_children():
		if child.is_in_group("bricks"):
			remove_child(child)
			child.queue_free()

func _on_button_pressed() -> void:
	if !debug:
		return

	var line_text := line_edit.text
	
	if line_text.length():
		noise = float(line_text)

	generate()

func load_sprites_from_folder(path: String) -> Array[int]:
	var result: Array[int] = []

	var dir := DirAccess.open(path)

	if dir == null:
		return result

	dir.list_dir_begin()

	var file_name := dir.get_next()

	while file_name != "":
		if not dir.current_is_dir():
			var file_path := path.path_join(file_name)

			if file_path.ends_with(".png") or file_path.ends_with(".webp"):
				var texture := load(file_path) as Texture2D

				if texture and texture.get_size() == Vector2(32, 32):
					var uid := ResourceLoader.get_resource_uid(file_path)

					if uid != ResourceUID.INVALID_ID:
						result.append(uid)
					#result.append(ResourceLoader.get_resource_uid(file_path))

		file_name = dir.get_next()

	dir.list_dir_end()

	return result
