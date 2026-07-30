extends HBoxContainer
class_name analyze_move_input

signal move_selected

var left_pokemon : PokemonData
var right_pokemon : PokemonData

func set_pokemon(pokemon: PokemonData, is_left = true) -> void:
	if is_left:
		left_pokemon = pokemon
		refresh_moves($LeftButton, left_pokemon)
	else:
		right_pokemon = pokemon
		refresh_moves($RightButton, right_pokemon)

func refresh_moves(button: OptionButton, pokemon: PokemonData) -> void:
	button.clear()
	for value in range(1,5):
		button.add_item(pokemon.get_move(value).name)
	button.select(0)

func set_selection(selection: Array[int]) -> void:
	$LeftButton.selected = selection[0]
	$RightButton.selected = selection[1]

func return_selection() -> Array[int]:
	return [$LeftButton.selected, $RightButton.selected]


func _on_item_selected(index: int) -> void:
	emit_signal("move_selected")
