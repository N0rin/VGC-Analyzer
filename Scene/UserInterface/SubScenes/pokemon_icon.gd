extends Control
class_name PokemonIcon

func set_sprite(x: int, y: int, source_id: int = 4):
	$MarginContainer/HBoxContainer/Icon/TileMap.set_cell(0, Vector2i.ZERO, source_id, Vector2i(x, y), 0)
