extends Node

signal hit_player(player: Player)
signal player_scored()
signal level_updated(new_level: int)
signal score_updated(player_1: int, player_2: int)

func emit_hit_player(player: Player):
	hit_player.emit(player)
