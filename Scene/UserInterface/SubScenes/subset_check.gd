extends HBoxContainer
class_name SubsetCheck

var set_data: PokemonData

func set_pokemon_data(pokemon_data: PokemonData):
	set_data = pokemon_data
	$Label.text = pokemon_data.set_name

func get_set_data() -> PokemonData:
	return set_data

func get_toggle_state() -> bool:
	return $CheckBox.button_pressed
