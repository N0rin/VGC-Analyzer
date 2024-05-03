extends PanelContainer
class_name SetSelectionItem

@onready var subset_check_scene = preload("res://Scene/UserInterface/SubScenes/subset_check.tscn")

@onready var subset_container = $MarginContainer/VBoxContainer/Subsets/SubsetContainer
@onready var species_label = $MarginContainer/VBoxContainer/Species/Label

func create_subsets(pokemon_set_list: Array[PokemonData]):
	for pokemon_set in pokemon_set_list:
		var subset = subset_check_scene.instantiate()
		subset.set_pokemon_data(pokemon_set)
		subset_container.add_child(subset)

func load_data(species_name: String, pokemon_set_list: Array[PokemonData]):
	species_label.text = species_name
	create_subsets(pokemon_set_list)
