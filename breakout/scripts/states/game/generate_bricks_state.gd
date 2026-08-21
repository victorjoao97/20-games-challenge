class_name GenerateBricksState extends State

@export var brick_generator: BrickGenerator
@export var playing_state: State
@export var game_state: Game

func enter() -> void:
	var step := (game_state.current_level - 1) / 5.0
	var noise_threshold := 0.5 - step * 0.1
	var min_noise := -0.5
	if game_state.debug:
		noise_threshold = 0.5 + step * 0.9
		min_noise = 0.9
	noise_threshold = max(noise_threshold, min_noise)
	brick_generator.noise = noise_threshold
	brick_generator.frequency = 0.05 + step * 0.01
	#brick_generator.seed_number = game_state.current_level
	brick_generator.generate()
	
	game_state.number_bricks = brick_generator.total_children
	switch_state.emit(playing_state)
