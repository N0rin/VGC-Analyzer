extends Control
const DATA_PATH = "res://Ressourcen/"

var pokemon_list: Array[Species]
var pokemon_set_list: Array[PokemonData]
var move_list: Array[Move]
var item_list: Array[Item]
var ability_list: Array[Ability]

@onready var pokemon_selector = $"MarginContainer/VBoxContainer/CoreUI/Left/Set Edit/Species"
@onready var set_selector = $"MarginContainer/VBoxContainer/CoreUI/Left/Set Edit/Set/SetSelect"
@onready var ability_selector = $"MarginContainer/VBoxContainer/CoreUI/Left/Set Edit/AbilitySelector/AbilityOption"
@onready var ability_selector_full = $"MarginContainer/VBoxContainer/CoreUI/Left/Set Edit/AbilitySelector/FullAbilityOption"
@onready var item_selector = $"MarginContainer/VBoxContainer/CoreUI/Left/Set Edit/ItemSelector/Item"
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
	clear_set()
	set_selector.set_item_metadata(0, null)
	
	for species in pokemon_list:
		if name in species.name:
			set_tera_type(species.main_type)
	
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
	ability_selector.clear()
	ability_selector_full.clear()
	item_selector.clear()
	for move_selector in move_selectors:
		move_selector.clear()
	
	clear_set()

func clear_set():
	set_selector.clear()
	set_selector.add_item("New Set", 0)
	set_tera_type("Normal")
	for node in $"MarginContainer/VBoxContainer/CoreUI/Left/Set Edit/Stats".get_children():
		if node is SpinBox:
			node.value = 0
	$"MarginContainer/VBoxContainer/CoreUI/Left/Set Edit/NatureSelector/NatureIncrease".select(0)
	$"MarginContainer/VBoxContainer/CoreUI/Left/Set Edit/NatureSelector/NatureDecrease".select(2)
	ability_selector.select(-1)
	ability_selector_full.select("")
	item_selector.select("")
	for move_selector in move_selectors:
		move_selector.select("")
	

func _on_back_pressed():
	hide()
	clear()

func _on_set_select_item_selected(index):
	var pokemon_set: PokemonData = set_selector.get_item_metadata(index)
	set_pokemon_data(pokemon_set)

func set_pokemon_data(pokemon_data: PokemonData):
	set_tera_type(pokemon_data.tera_type)
	set_training_values(pokemon_data)
	set_nature(pokemon_data)
	set_item_and_ability(pokemon_data)
	set_moves(pokemon_data)

func set_tera_type(type_name:String):
	var index = 0
	match(type_name):
		"Bug":
			index = 0
		"Dark":
			index = 1
		"Dragon":
			index = 2
		"Electric":
			index = 3
		"Fairy":
			index = 4
		"Fighting":
			index = 5
		"Fire":
			index = 6
		"Flying":
			index = 7
		"Ghost":
			index = 8
		"Grass":
			index = 9
		"Ground":
			index = 10
		"Ice":
			index = 11
		"Normal":
			index = 12
		"Poison":
			index = 13
		"Psychic": 
			index = 14
		"Rock":
			index = 15
		"Steel":
			index = 16
		"Water":
			index = 17
		"Stellar":
			index = 18
	$"MarginContainer/VBoxContainer/CoreUI/Left/Set Edit/Tera/OptionButton".select(index)

func set_training_values(pokemon_data: PokemonData):
	var container_node = $"MarginContainer/VBoxContainer/CoreUI/Left/Set Edit/Stats"
	container_node.get_node("HpIv").value = pokemon_data.hp_ivs
	container_node.get_node("AtkIv").value = pokemon_data.atk_ivs
	container_node.get_node("DefIv").value = pokemon_data.def_ivs
	container_node.get_node("SpaIv").value = pokemon_data.spa_ivs
	container_node.get_node("SpdIv").value = pokemon_data.spd_ivs
	container_node.get_node("SpeIv").value = pokemon_data.spe_ivs
	
	container_node.get_node("HpEv").value = pokemon_data.hp_evs
	container_node.get_node("AtkEv").value = pokemon_data.atk_evs
	container_node.get_node("DefEv").value = pokemon_data.def_evs
	container_node.get_node("SpaEv").value = pokemon_data.spa_evs
	container_node.get_node("SpdEv").value = pokemon_data.spd_evs
	container_node.get_node("SpeEv").value = pokemon_data.spe_evs

func set_nature(pokemon_data: PokemonData):
	var increase_selector = $"MarginContainer/VBoxContainer/CoreUI/Left/Set Edit/NatureSelector/NatureIncrease"
	var reduced_selector = $"MarginContainer/VBoxContainer/CoreUI/Left/Set Edit/NatureSelector/NatureDecrease"
	match(pokemon_data.increased_stat):
		"Atk":
			increase_selector.select(0)
		"Def":
			increase_selector.select(1)
		"SpA":
			increase_selector.select(2)
		"SpD":
			increase_selector.select(3)
		"Spe":
			increase_selector.select(4)
			
	match(pokemon_data.reduced_stat):
		"Atk":
			reduced_selector.select(0)
		"Def":
			reduced_selector.select(1)
		"SpA":
			reduced_selector.select(2)
		"SpD":
			reduced_selector.select(3)
		"Spe":
			reduced_selector.select(4)

func set_item_and_ability(pokemon_data: PokemonData):
	ability_selector_full.select(pokemon_data.ability.name)
	item_selector.select(pokemon_data.item.name)

func set_moves(pokemon_data: PokemonData):
	move_selector1.select(pokemon_data.move1.name)
	move_selector2.select(pokemon_data.move2.name)
	move_selector3.select(pokemon_data.move3.name)
	move_selector4.select(pokemon_data.move4.name)
