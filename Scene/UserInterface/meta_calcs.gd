extends Control
const DATA_PATH = "res://Ressourcen/"

var pokemon_list: Array[Species]
var pokemon_set_list: Array[PokemonData]

@onready var pokemon_selector = $"MarginContainer/VBoxContainer/CoreUI/Left/Set Edit/Species"
@onready var set_selector = $"MarginContainer/VBoxContainer/CoreUI/Left/Set Edit/Set/SetSelect"

func load_saved_pokemon_data():
	var dir = DirAccess.open(DATA_PATH)
	var species_files_list = dir.get_files_at(DATA_PATH +"Species")
	var set_files_list = dir.get_files_at(DATA_PATH +"PokemonSets")
	
	for species_filename in species_files_list:
		pokemon_list.append(load(DATA_PATH + "Species/" + species_filename))
	
	for set_filename in set_files_list:
		pokemon_set_list.append(load(DATA_PATH + "PokemonSets/" + set_filename))
		
	update_interface()

func update_interface():
	update_pokemon_selector()

func update_pokemon_selector():
	pokemon_selector.clear()
	for pokemon in pokemon_list:
		pokemon_selector.add_item(pokemon.name)

func _on_species_item_selected(name):
	set_selector.clear()
	set_selector.add_item("New Set", 0)
	set_selector.set_item_metadata(0, null)
	
	var id = 1
	for set in pokemon_set_list:
		if set.species.name == name:
			set_selector.add_item(set.set_name, id)
			set_selector.set_item_metadata(id, set)
			id += 1


func _on_back_pressed():
	hide()
	#reset
