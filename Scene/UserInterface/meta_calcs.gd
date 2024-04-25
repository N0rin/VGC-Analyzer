extends Control
const DATA_PATH = "res://Ressourcen/"

var pokemon_list: Array[Species]
var pokemon_set_list: Array[PokemonData]
var move_list: Array[Move]
var item_list: Array[Item]
var ability_list: Array[Ability]

@onready var pokemon_selector = $"MarginContainer/VBoxContainer/CoreUI/Left/Set Edit/Species"
@onready var set_selector = $"MarginContainer/VBoxContainer/CoreUI/Left/Set Edit/Set/SetSelect"
@onready var ability_selector = $"MarginContainer/VBoxContainer/CoreUI/Left/Set Edit/GridContainer2/AbilityOption"
@onready var ability_selector_full = $"MarginContainer/VBoxContainer/CoreUI/Left/Set Edit/GridContainer2/FullAbilityOption"
@onready var item_selector = $"MarginContainer/VBoxContainer/CoreUI/Left/Set Edit/GridContainer2/Item"
@onready var move_selector1 = $"MarginContainer/VBoxContainer/CoreUI/Left/Set Edit/Moves/Move1"
@onready var move_selector2 = $"MarginContainer/VBoxContainer/CoreUI/Left/Set Edit/Moves/Move2"
@onready var move_selector3 = $"MarginContainer/VBoxContainer/CoreUI/Left/Set Edit/Moves/Move3"
@onready var move_selector4 = $"MarginContainer/VBoxContainer/CoreUI/Left/Set Edit/Moves/Move4"
@onready var move_selectors = [move_selector1, move_selector2, move_selector3, move_selector4]

func load_saved_pokemon_data():
	load_into_list(pokemon_list, "Species")
	load_into_list(pokemon_set_list, "PokemonSets")
	load_into_list(move_list, "Moves")
	load_into_list(item_list, "Items")
	load_into_list(ability_list, "Abilities")
	
	update_interface()

func load_into_list(list: Array, dirname):
	var dir = DirAccess.open(DATA_PATH)
	var file_list = dir.get_files_at(DATA_PATH + dirname)
	
	for filename in file_list:
		list.append(load(DATA_PATH + dirname + "/" + filename))

func update_interface():
	update_pokemon_selector()
	update_ability_selector()
	update_item_selector()
	update_move_selector()

func update_pokemon_selector():
	pokemon_selector.clear()
	for pokemon in pokemon_list:
		pokemon_selector.add_item(pokemon.name)

func update_ability_selector():
	ability_selector_full.clear()
	for ability in ability_list:
		ability_selector_full.add_item(ability.name)

func update_item_selector():
	item_selector.clear()
	for item in item_list:
		item_selector.add_item(item.name)

func update_move_selector():
	for move_selector in move_selectors:
		move_selector.clear()
		for move in move_list:
			move_selector.add_item(move.name)

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

func clear():
	pokemon_list.clear()
	pokemon_set_list.clear()
	ability_list.clear()
	item_list.clear()
	move_list.clear()
	
	pokemon_selector.clear()
	set_selector.clear()
	ability_selector.clear()
	ability_selector_full.clear()
	item_selector.clear()
	for move_selector in move_selectors:
		move_selector.clear()
	

func _on_back_pressed():
	hide()
	clear()


func _on_set_select_item_selected(index):
	pass # Replace with function body.
