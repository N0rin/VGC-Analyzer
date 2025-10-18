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
	
	set_edit.update_interface(pokemon_list,item_list,move_list,pokemon_set_list)

func load_into_list(list: Array, dirname: String):
	var dir = DirAccess.open(DATA_PATH)
	var file_list = dir.get_files_at(DATA_PATH + dirname)
	
	for filename in file_list:
		list.append(load(DATA_PATH + dirname + "/" + filename))

func get_pokemon_data() -> PokemonData:
	var data = PokemonData.new()
	data.species = find_by_name(pokemon_list, set_edit.pokemon_selector.selected)
	data.ability = find_by_name(ability_list, set_edit.ability_selector.get_item_text(set_edit.ability_selector.selected))
	data.item = find_by_name(item_list, set_edit.item_selector.selected)
	data.tera_type = set_edit.get_selected_tera_type()
	data.increased_stat = set_edit.get_increased_stat()
	data.reduced_stat = set_edit.get_decreased_stat()
	data.hp_evs = set_edit.get_evs(0)
	data.atk_evs = set_edit.get_evs(1)
	data.def_evs = set_edit.get_evs(2)
	data.spa_evs = set_edit.get_evs(3)
	data.spd_evs = set_edit.get_evs(4)
	data.spe_evs = set_edit.get_evs(5)
	data.hp_ivs = set_edit.get_ivs(0)
	data.atk_ivs = set_edit.get_ivs(1)
	data.def_ivs = set_edit.get_ivs(2)
	data.spa_ivs = set_edit.get_ivs(3)
	data.spd_ivs = set_edit.get_ivs(4)
	data.spe_ivs = set_edit.get_ivs(5)
	data.move1 = find_by_name(move_list, set_edit.move_selector1.selected)
	data.move2 = find_by_name(move_list, set_edit.move_selector2.selected)
	data.move3 = find_by_name(move_list, set_edit.move_selector3.selected)
	data.move4 = find_by_name(move_list, set_edit.move_selector4.selected)
	return data

func save_set(set_name: String):
	var pokemon_set : PokemonData = get_pokemon_data()
	pokemon_set.name = set_name
	pokemon_set.format = $PopupPanel/MarginContainer/VBoxContainer/HBoxContainer2/FormatSelect.selected
	var resource_path = "%sPokemonSets/%s_%s.tres" % [DATA_PATH, pokemon_set.species.name.format("_", " "), set_name.format("_", " ")]
	var result = ResourceSaver.save(pokemon_set, resource_path)
	assert(result == OK)
	
	pokemon_set_list.append(pokemon_set)

func find_by_name(list: Array, name: String):
	for thing in list:
		if thing.name == name:
			return thing

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
