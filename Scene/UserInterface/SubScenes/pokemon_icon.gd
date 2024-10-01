extends Control
class_name PokemonIcon

func set_sprite(x: int, y: int, source_id: int = 4):
	match(source_id):
		0:
			$Gen9List.set_cell(Vector2i.ZERO, source_id, Vector2i(x, y), 0)
		4:
			$NationalList.set_cell(Vector2i.ZERO, source_id, Vector2i(x, y), 0)
