extends Control
const DATA_PATH = "res://Ressourcen/"

@onready var set_selection_item_scene = preload("res://Scene/UserInterface/SubScenes/set_selection_item.tscn")
@onready var move_calc_item_scene = preload("res://Scene/UserInterface/SubScenes/move_calc_item.tscn")

var pokemon_list: Array[Species]
var pokemon_set_list: Array[PokemonData]
var move_list: Array[Move]
var item_list: Array[Item]
var ability_list: Array[Ability]

var is_left_attacker = true

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
@onready var right_set_selection = $MarginContainer/VBoxContainer/CoreUI/Right/Scroll/VBoxContainer
@onready var middle_move_list = $MarginContainer/VBoxContainer/CoreUI/Middle/MiddleScroll/MoveList

func load_saved_pokemon_data():
	load_into_list(pokemon_list, "Species")
	load_into_list(pokemon_set_list, "PokemonSets")
	load_into_list(move_list, "Moves")
	load_into_list(item_list, "Items")
	load_into_list(ability_list, "Abilities")
	
	update_interface()

func load_into_list(list: Array, dirname: String):
	var dir = DirAccess.open(DATA_PATH)
	var file_list = dir.get_files_at(DATA_PATH + dirname)
	
	for filename in file_list:
		list.append(load(DATA_PATH + dirname + "/" + filename))

func update_interface():
	update_pokemon_selector()
	update_ability_selector()
	update_item_selector()
	update_move_selector()
	
	update_right_set_selection()

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

func update_right_set_selection():
	for pokemon in pokemon_list:
		if get_pokemon_set_from_species(pokemon.name).size() == 0:
			continue
		
		var set_selection_item = set_selection_item_scene.instantiate()
		right_set_selection.add_child(set_selection_item)
		set_selection_item.load_data(pokemon.name, get_pokemon_set_from_species(pokemon.name))
		set_selection_item.toggled.connect(_on_right_box_toggled)

func update_middle():
	clear_middle_selection()
	var test_pokemon = Pokemon.new()
	test_pokemon.state = PokemonState.new()
	test_pokemon.data = get_left_pokemon_data()
	var context = AttackContext.new()
	
	var move_calc_list: Array[MoveCalcItem]
	for set_selection_item: SetSelectionItem in right_set_selection.get_children():
		for meta_set in set_selection_item.get_sets():
			var meta_pokemon = Pokemon.new()
			meta_pokemon.state = PokemonState.new()
			meta_pokemon.data = meta_set
			
			if is_left_attacker:
				context.attacker = test_pokemon
				context.defender = meta_pokemon
			else:
				context.attacker = meta_pokemon
				context.defender = test_pokemon
			
			for move_value in range(1,4):
				context.used_attack = move_value
				if context.get_move():
					match(context.get_move().category):
						"Physical", "Special":
							var move_calc_item = move_calc_item_scene.instantiate()
							move_calc_item.load_attack(context)
							move_calc_list.append(move_calc_item)
	move_calc_list.sort_custom(func(a,b): return a.max_damage > b.max_damage)
	for move_calc_item in move_calc_list:
		middle_move_list.add_child(move_calc_item)

func get_left_pokemon_data() -> PokemonData:
	var data = PokemonData.new()
	data.species = find_by_name(pokemon_list, pokemon_selector.selected)
	data.ability = find_by_name(ability_list, ability_selector_full.selected)
	data.item = find_by_name(item_list, item_selector.selected)
	data.tera_type = get_selected_tera_type()
	data.increased_stat = get_modified_stat($"MarginContainer/VBoxContainer/CoreUI/Left/Set Edit/NatureSelector/NatureIncrease".selected)
	data.reduced_stat = get_modified_stat($"MarginContainer/VBoxContainer/CoreUI/Left/Set Edit/NatureSelector/NatureDecrease".selected)
	data.hp_evs = $"MarginContainer/VBoxContainer/CoreUI/Left/Set Edit/Stats/HpEv".value
	data.atk_evs = $"MarginContainer/VBoxContainer/CoreUI/Left/Set Edit/Stats/AtkEv".value
	data.def_evs = $"MarginContainer/VBoxContainer/CoreUI/Left/Set Edit/Stats/DefEv".value
	data.spa_evs = $"MarginContainer/VBoxContainer/CoreUI/Left/Set Edit/Stats/SpaEv".value
	data.spd_evs = $"MarginContainer/VBoxContainer/CoreUI/Left/Set Edit/Stats/SpdEv".value
	data.spe_evs = $"MarginContainer/VBoxContainer/CoreUI/Left/Set Edit/Stats/SpeEv".value
	data.hp_ivs = $"MarginContainer/VBoxContainer/CoreUI/Left/Set Edit/Stats/HpIv".value
	data.atk_ivs = $"MarginContainer/VBoxContainer/CoreUI/Left/Set Edit/Stats/AtkIv".value
	data.def_ivs = $"MarginContainer/VBoxContainer/CoreUI/Left/Set Edit/Stats/DefIv".value
	data.spa_ivs = $"MarginContainer/VBoxContainer/CoreUI/Left/Set Edit/Stats/SpaIv".value
	data.spd_ivs = $"MarginContainer/VBoxContainer/CoreUI/Left/Set Edit/Stats/SpdIv".value
	data.spe_ivs = $"MarginContainer/VBoxContainer/CoreUI/Left/Set Edit/Stats/SpeIv".value
	data.move1 = find_by_name(move_list, move_selector1.selected)
	data.move2 = find_by_name(move_list, move_selector2.selected)
	data.move3 = find_by_name(move_list, move_selector3.selected)
	data.move4 = find_by_name(move_list, move_selector4.selected)
	return data

func _on_species_item_selected(name):
	clear_set()
	set_selector.clear()
	set_selector.add_item("New Set", 0)
	set_selector.set_item_metadata(0, null)
	clear_middle_selection()
	
	for species in pokemon_list:
		if name in species.name:
			set_tera_type(species.main_type)
	
	var id = 1
	for pokemon_set in get_pokemon_set_from_species(name):
		set_selector.add_item(pokemon_set.set_name, id)
		set_selector.set_item_metadata(id, pokemon_set)
		id += 1

func _on_right_box_toggled(toggled_on):
	var all_pressed = true
	var all_unpressed = true
	for right_set_item in right_set_selection.get_children():
		if right_set_item.get_toggle_state():
			all_unpressed = false
		else:
			all_pressed = false
	
	if all_pressed:
		$MarginContainer/VBoxContainer/CoreUI/Right/AllCheck.button_pressed = true
	if all_unpressed:
		$MarginContainer/VBoxContainer/CoreUI/Right/AllCheck.button_pressed = false
	
	update_middle()

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
	
	set_selector.clear()
	set_selector.add_item("New Set", 0)
	clear_set()
	
	clear_right_selection()
	clear_middle_selection()

func clear_set():
	set_tera_type("Normal")
	for node in $"MarginContainer/VBoxContainer/CoreUI/Left/Set Edit/Stats".get_children():
		if node is EvSpinBox:
			node.value = 0
		elif node is SpinBox:
			node.value = 31
	$"MarginContainer/VBoxContainer/CoreUI/Left/Set Edit/NatureSelector/NatureIncrease".select(0)
	$"MarginContainer/VBoxContainer/CoreUI/Left/Set Edit/NatureSelector/NatureDecrease".select(2)
	ability_selector.select(-1)
	ability_selector_full.select("")
	item_selector.select("")
	for move_selector in move_selectors:
		move_selector.select("")

func clear_right_selection():
	for child in right_set_selection.get_children():
		right_set_selection.remove_child(child)
		child.queue_free()

func clear_middle_selection():
	for child in middle_move_list.get_children():
		middle_move_list.remove_child(child)
		child.queue_free()

func _on_back_pressed():
	hide()
	clear()

func _on_set_select_item_selected(index):
	var pokemon_set: PokemonData = set_selector.get_item_metadata(index)
	if pokemon_set:
		set_pokemon_data(pokemon_set)
	else:
		clear_set()
	update_middle()

func get_pokemon_set_from_species(name: String) -> Array[PokemonData]:
	var list: Array[PokemonData]
	
	for pokemon_set in pokemon_set_list:
		if pokemon_set.species.name == name:
			list.append(pokemon_set)
	
	return list

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

func get_selected_tera_type() -> String:
	var index = $"MarginContainer/VBoxContainer/CoreUI/Left/Set Edit/Tera/OptionButton".selected
	match(index):
		0:
			return "Bug"
		1:
			return "Dark"
		2:
			return "Dragon"
		3:
			return "Electric"
		4:
			return "Fairy"
		5:
			return "Fighting"
		6:
			return "Fire"
		7:
			return "Flying"
		8:
			return "Ghost"
		9:
			return "Grass"
		10:
			return "Ground"
		11:
			return "Ice"
		12:
			return "Normal"
		13:
			return "Poison"
		14:
			return "Psychic"
		15:
			return "Rock"
		16:
			return "Steel"
		17:
			return "Water"
		18:
			return "Stellar"
	return ""

func get_modified_stat(index: int) -> String:
	match(index):
		0:
			return "Atk"
		1:
			return "Def"
		2:
			return "SpA"
		3:
			return "SpD"
		4:
			return "Spe"
	return ""

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

func _on_all_check_toggled(toggled_on):
	for right_set_item in right_set_selection.get_children():
		right_set_item.set_toggle_state(toggled_on)
	update_middle()

func find_by_name(list: Array, name: String):
	for thing in list:
		if thing.name == name:
			return thing

func _on_toggle_attacker_pressed():
	if is_left_attacker:
		is_left_attacker = false
		$MarginContainer/VBoxContainer/Bottom/ToggleAttacker.text = " Defense "
	else:
		is_left_attacker = true
		$MarginContainer/VBoxContainer/Bottom/ToggleAttacker.text = " Offense "
	update_middle()
