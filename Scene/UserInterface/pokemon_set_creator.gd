extends Control

const DATA_PATH = "res://Ressourcen/"

var pokemon_list: Array[Species]
var pokemon_set_list: Array[PokemonData]
var move_list: Array[Move]
var item_list: Array[Item]
var ability_list: Array[Ability]

@onready var set_edit = $"MarginContainer/VBoxContainer/CoreUI/Middle/Set Edit"
@onready var new_set_name = $PopupPanel/MarginContainer/VBoxContainer/HBoxContainer2/TextEdit

func load_saved_pokemon_data():
	load_into_list(pokemon_list, "Species")
	load_into_list(pokemon_set_list, "PokemonSets")
	load_into_list(move_list, "Moves")
	load_into_list(item_list, "Items")
	load_into_list(ability_list, "Abilities")
	
	set_edit.update_interface(pokemon_list,item_list,ability_list,move_list,pokemon_set_list)

func load_into_list(list: Array, dirname: String):
	var dir = DirAccess.open(DATA_PATH)
	var file_list = dir.get_files_at(DATA_PATH + dirname)
	
	for filename in file_list:
		list.append(load(DATA_PATH + dirname + "/" + filename))

func save_set(set_name: String):
	var pokemon_set : PokemonData = set_edit.get_pokemon_data()
	pokemon_set.name = set_name
	pokemon_set.format = $PopupPanel/MarginContainer/VBoxContainer/HBoxContainer2/FormatSelect.selected
	var resource_path = "%sPokemonSets/%s_%s.tres" % [DATA_PATH, pokemon_set.species.name.format("_", " "), set_name.format("_", " ")]
	var result = ResourceSaver.save(pokemon_set, resource_path)
	assert(result == OK)
	
	pokemon_set_list.append(pokemon_set)

func _on_back_pressed():
	hide()
	set_edit.clear()

func _on_save_pressed():
	$PopupPanel.show()

func _on_confirm_pressed():
	if new_set_name.text != "":
		save_set(new_set_name.text)
		$PopupPanel.hide()

func _on_cancel_pressed():
	$PopupPanel.hide()
