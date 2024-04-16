extends Control
const DATA_PATH = "res://Ressourcen/"

var pokemon_list: Array[Species]
var pokemon_set_list: Array[PokemonData]

func load_saved_pokemon_data():
	var dir = DirAccess.open(DATA_PATH)
	var species_files_list = dir.get_files_at("Species/")
	var set_files_list = dir.get_files_at("PokemonSets/")
	
	for species_filename in species_files_list:
		pokemon_list.append(load(DATA_PATH + "Species/" + species_filename))
	
	for set_filename in set_files_list:
		pokemon_set_list.append(load(DATA_PATH + "PokemonSets/" + set_filename))
