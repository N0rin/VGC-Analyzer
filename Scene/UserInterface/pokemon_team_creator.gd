extends Control

const DATA_PATH = "res://Ressourcen/"

var team_name = "Testing"
var selected_member = 0

var pokemon_list: Array[Species]
var pokemon_set_list: Array[PokemonData]
var pokemon_team_list: Array[TeamData]

var move_list: Array[Move]
var item_list: Array[Item]
var ability_list: Array[Ability]

var team_members: Array[PokemonData] = [null, null, null, null, null, null]

@onready var set_edit = $"MarginContainer/VBoxContainer/CoreUI/Right/Set Edit"

func _ready() -> void:
	$MarginContainer/VBoxContainer/CoreUI/Middle/PokemonButton/Button.button_pressed = true

func load_saved_pokemon_data():
	load_into_list(pokemon_list, "Species")
	load_into_list(pokemon_set_list, "PokemonSets")
	load_into_list(pokemon_team_list, "Teams")
	load_into_list(move_list, "Moves")
	load_into_list(item_list, "Items")
	load_into_list(ability_list, "Abilities")
	
	set_edit.update_interface(pokemon_list,item_list,ability_list,move_list,pokemon_set_list)

func load_into_list(list: Array, dirname: String):
	var dir = DirAccess.open(DATA_PATH)
	var file_list = dir.get_files_at(DATA_PATH + dirname)
	
	for filename in file_list:
		list.append(load(DATA_PATH + dirname + "/" + filename))

func _on_set_edit_pokemon_selected(pokemon: Species) -> void:
	match selected_member:
		0:
			$MarginContainer/VBoxContainer/CoreUI/Middle/PokemonButton.set_pokemon(pokemon)
		1:
			$MarginContainer/VBoxContainer/CoreUI/Middle/PokemonButton2.set_pokemon(pokemon)
		2:
			$MarginContainer/VBoxContainer/CoreUI/Middle/PokemonButton3.set_pokemon(pokemon)
		3:
			$MarginContainer/VBoxContainer/CoreUI/Middle/PokemonButton4.set_pokemon(pokemon)
		4:
			$MarginContainer/VBoxContainer/CoreUI/Middle/PokemonButton5.set_pokemon(pokemon)
		5:
			$MarginContainer/VBoxContainer/CoreUI/Middle/PokemonButton6.set_pokemon(pokemon)


func _on_pokemon_button_id_pressed(id) -> void:
	match selected_member:
		0:
			$MarginContainer/VBoxContainer/CoreUI/Middle/PokemonButton/Button.button_pressed = false
		1:
			$MarginContainer/VBoxContainer/CoreUI/Middle/PokemonButton2/Button.button_pressed = false
		2:
			$MarginContainer/VBoxContainer/CoreUI/Middle/PokemonButton3/Button.button_pressed = false
		3:
			$MarginContainer/VBoxContainer/CoreUI/Middle/PokemonButton4/Button.button_pressed = false
		4:
			$MarginContainer/VBoxContainer/CoreUI/Middle/PokemonButton5/Button.button_pressed = false
		5:
			$MarginContainer/VBoxContainer/CoreUI/Middle/PokemonButton6/Button.button_pressed = false
	
	team_members[selected_member] = set_edit.get_pokemon_data()
	team_members[selected_member].name = "Current"
	selected_member = id
	set_edit.set_pokemon_data(team_members[id])
