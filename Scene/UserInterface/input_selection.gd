extends HBoxContainer
class_name analyze_move_input

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
