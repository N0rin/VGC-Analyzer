extends Control
const DATA_PATH = "res://Ressourcen/"

@onready var set_selection_item_scene = preload("res://Scene/UserInterface/SubScenes/set_selection_item.tscn")
@onready var move_calc_item_scene = preload("res://Scene/UserInterface/SubScenes/move_calc_item.tscn")

var pokemon_list: Array[Species]
var pokemon_set_list: Array[PokemonData]

var is_left_attacker = true

@onready var set_edit : SetEdit = $"MarginContainer/VBoxContainer/CoreUI/Left/Set Edit"
@onready var right_set_selection = $MarginContainer/VBoxContainer/CoreUI/Right/Scroll/VBoxContainer
@onready var middle_move_list = $MarginContainer/VBoxContainer/CoreUI/Middle/MiddleScroll/MoveList


#Loading
func startup():
	set_edit.load_saved_pokemon_data()
	load_into_list(pokemon_list, "Species")
	load_into_list(pokemon_set_list, "PokemonSets")
	
	update_right_set_selection()
	show()

func load_into_list(list: Array, dirname: String):
	DirAccess.open(DATA_PATH)
	var file_list = DirAccess.get_files_at(DATA_PATH + dirname)
	
	for filename in file_list:
		list.append(load(DATA_PATH + dirname + "/" + filename))

#Interface
func update_right_set_selection():
	for pokemon in pokemon_list:
		if get_pokemon_set_from_species(pokemon.name).size() == 0:
			continue
		
		var set_selection_item = set_selection_item_scene.instantiate()
		right_set_selection.add_child(set_selection_item)
		set_selection_item.load_data(pokemon.name, get_pokemon_set_from_species(pokemon.name))
		set_selection_item.toggled.connect(_on_right_box_toggled)

func update_move_calcs(only_strongest = true):
	clear_move_calcs()
	var test_pokemon = Pokemon.new()
	test_pokemon.state = PokemonState.new()
	test_pokemon.data = set_edit.get_pokemon_data()
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
			
			var move_list : Array[MoveCalcItem]
			
			for move_value in range(1,5):
				context.used_attack = move_value
				if context.get_move():
					match(context.get_move().category):
						"Physical", "Special":
							var move_calc_item = move_calc_item_scene.instantiate()
							context = $MarginContainer/VBoxContainer/CoreUI/Left/Factors.modify_context(context)
							if context.get_move().targeting == "All" or context.get_move().targeting == "Enemies":
								context.is_spread = true
							else:
								context.is_spread = false
								
							move_calc_item.load_attack(context)
							move_list.append(move_calc_item)
			if only_strongest:
				if not move_list.is_empty():
					move_list.sort_custom(func(a,b): return a.max_damage > b.max_damage)
					move_calc_list.append(move_list[0])
			else:
				move_calc_list.append_array(move_list)
	
	
	move_calc_list.sort_custom(func(a,b): return a.max_damage > b.max_damage)
	for move_calc_item in move_calc_list:
		middle_move_list.add_child(move_calc_item)

func clear():
	pokemon_list.clear()
	pokemon_set_list.clear()
	set_edit.clear()
	
	clear_right_selection()
	clear_move_calcs()

func clear_right_selection():
	for child in right_set_selection.get_children():
		right_set_selection.remove_child(child)
		child.queue_free()

func clear_move_calcs():
	for child in middle_move_list.get_children():
		middle_move_list.remove_child(child)
		child.queue_free()

#Getter
func get_pokemon_set_from_species(species_name: String) -> Array[PokemonData]:
	var list: Array[PokemonData]
	
	for pokemon_set in pokemon_set_list:
		if pokemon_set.species.name == species_name:
			list.append(pokemon_set)
	
	return list

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

#Signal Reactions
func _on_set_edit_set_selected() -> void:
	update_move_calcs()

func _on_right_box_toggled():
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
	
	update_move_calcs()

func _on_all_check_toggled(toggled_on):
	for right_set_item in right_set_selection.get_children():
		right_set_item.set_toggle_state(toggled_on)
	update_move_calcs()

func _on_toggle_attacker_pressed():
	if is_left_attacker:
		is_left_attacker = false
		$MarginContainer/VBoxContainer/Bottom/ToggleAttacker.text = " Defense "
	else:
		is_left_attacker = true
		$MarginContainer/VBoxContainer/Bottom/ToggleAttacker.text = " Offense "
	update_move_calcs()

func _on_back_pressed():
	hide()
	clear()
