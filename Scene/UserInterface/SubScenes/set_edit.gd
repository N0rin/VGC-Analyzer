extends VBoxContainer
class_name SetEdit

signal pokemon_selected(Species)

@onready var pokemon_selector = $"Species"
@onready var set_selector = $"Set/SetSelect"
@onready var tera_selector = $"Tera/TeraSelect"
@onready var ability_selector = $"AbilitySelector/AbilityOption"
@onready var item_selector = $"ItemSelector/Item"
@onready var move_selector1 = $"Moves/Move1"
@onready var move_selector2 = $"Moves/Move2"
@onready var move_selector3 = $"Moves/Move3"
@onready var move_selector4 = $"Moves/Move4"
@onready var move_selectors = [move_selector1, move_selector2, move_selector3, move_selector4]

@onready var pokemon_list: Array[Species]
@onready var item_list: Array[Item]
@onready var ability_list: Array[Ability]
@onready var move_list: Array[Move]
@onready var pokemon_set_list: Array[PokemonData]


#Getter
func get_evs(index:int) -> int:
	match index:
		0:
			return $"Stats/HpEv".value
		1:
			return $"Stats/AtkEv".value
		2:
			return $"Stats/DefEv".value
		3:
			return $"Stats/SpaEv".value
		4:
			return $"Stats/SpdEv".value
		5:
			return $"Stats/SpeEv".value
	return 0

func get_ivs(index:int) -> int:
	match index:
		0:
			return $"Stats/HpIv".value
		1:
			return $"Stats/AtkIv".value
		2:
			return $"Stats/DefIv".value
		3:
			return $"Stats/SpaIv".value
		4:
			return $"Stats/SpdIv".value
		5:
			return $"Stats/SpeIv".value
	return 0

func get_increased_stat() -> String:
	return get_modified_stat($"NatureSelector/NatureIncrease".selected)

func get_decreased_stat() -> String:
	return get_modified_stat($"NatureSelector/NatureDecrease".selected)

func get_selected_tera_type() -> String:
	var index = $"Tera/TeraSelect".selected
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

func get_pokemon_set_from_species(name: String) -> Array[PokemonData]:
	var list: Array[PokemonData]
	
	for pokemon_set in pokemon_set_list:
		if pokemon_set.species.name == name:
			list.append(pokemon_set)
	
	return list

func get_format(value : int) -> String:
	match (value):
		1:
			return "Reg A"
		2:
			return "Reg B"
		3:
			return "Reg C"
		4:
			return "Reg D"
		5:
			return "Reg E"
		6:
			return "Reg F"
		7:
			return "Reg G"
		8:
			return "Reg H"
	
	return "All"

func get_pokemon_data() -> PokemonData:
	var data = PokemonData.new()
	data.species = find_by_name(pokemon_list, pokemon_selector.selected)
	data.ability = find_by_name(ability_list, ability_selector.get_item_text(ability_selector.selected))
	data.item = find_by_name(item_list, item_selector.selected)
	data.tera_type = get_selected_tera_type()
	data.increased_stat = get_increased_stat()
	data.reduced_stat = get_decreased_stat()
	data.hp_evs = get_evs(0)
	data.atk_evs = get_evs(1)
	data.def_evs = get_evs(2)
	data.spa_evs = get_evs(3)
	data.spd_evs = get_evs(4)
	data.spe_evs = get_evs(5)
	data.hp_ivs = get_ivs(0)
	data.atk_ivs = get_ivs(1)
	data.def_ivs = get_ivs(2)
	data.spa_ivs = get_ivs(3)
	data.spd_ivs = get_ivs(4)
	data.spe_ivs = get_ivs(5)
	data.move1 = find_by_name(move_list, move_selector1.selected)
	data.move2 = find_by_name(move_list, move_selector2.selected)
	data.move3 = find_by_name(move_list, move_selector3.selected)
	data.move4 = find_by_name(move_list, move_selector4.selected)
	return data

func find_by_name(list: Array, name: String):
	for thing in list:
		if thing.name == name:
			return thing

#Interface Updates
func update_interface(new_pokemon_list:Array[Species], new_item_list:Array[Item], new_ability_list:Array[Ability], new_move_list:Array[Move], new_pokemon_set_list:Array[PokemonData]):
	pokemon_list = new_pokemon_list
	item_list = new_item_list
	move_list = new_move_list
	pokemon_set_list = new_pokemon_set_list
	ability_list = new_ability_list
	update_pokemon_selector(new_pokemon_list)
	update_item_selector(new_item_list)
	update_move_selector(new_move_list)

func update_pokemon_selector(pokemon_list: Array[Species]):
	pokemon_selector.clear()
	for pokemon in pokemon_list:
		pokemon_selector.add_item(pokemon.name)

func update_item_selector(item_list:Array[Item]):
	item_selector.clear()
	for item in item_list:
		item_selector.add_item(item.name)

func update_move_selector(move_list:Array[Move]):
	for move_selector in move_selectors:
		move_selector.clear()
		for move in move_list:
			move_selector.add_item(move.name)

func clear_set():
	set_tera_type("")
	for node in $"Stats".get_children():
		if node is EvSpinBox:
			node.value = 0
		elif node is SpinBox:
			node.value = 31
	$"NatureSelector/NatureIncrease".select(0)
	$"NatureSelector/NatureDecrease".select(2)
	ability_selector.select(0)
	item_selector.select("")
	for move_selector in move_selectors:
		move_selector.select("")

func clear_species():
	pokemon_selector.select("")
	clear_set()
	set_selector.clear()
	ability_selector.clear()

func clear():
	pokemon_list.clear()
	pokemon_set_list.clear()
	item_list.clear()
	move_list.clear()
	
	pokemon_selector.clear()
	ability_selector.clear()
	item_selector.clear()
	for move_selector in move_selectors:
		move_selector.clear()
	
	set_selector.clear()
	set_selector.add_item("New Set", 0)
	clear_set()


#Setter
func set_pokemon_data(pokemon_data: PokemonData):
	if pokemon_data == null:
		clear_species()
		return
	if pokemon_data.species == null:
		clear_species()
		return
	pokemon_selector.select(pokemon_data.species.name)
	set_tera_type(pokemon_data.tera_type)
	set_training_values(pokemon_data)
	set_nature(pokemon_data)
	set_item(pokemon_data)
	set_moves(pokemon_data)
	
	set_selector.clear()
	set_selector.add_item("New Set", 0)
	set_selector.set_item_metadata(0, null)
	set_selector.add_item("Current", 1)
	set_selector.set_item_metadata(1, pokemon_data)
	var id = 2
	for pokemon_set in get_pokemon_set_from_species(pokemon_data.species.name):
		set_selector.add_item(get_format(pokemon_set.format) +" - "+ pokemon_set.name, id)
		set_selector.set_item_metadata(id, pokemon_set)
		id += 1
	set_selector.select(1)
	
	ability_selector.clear()
	if pokemon_data.species.ability1:
		ability_selector.add_item(pokemon_data.species.ability1.name)
	if pokemon_data.species.ability2:
		ability_selector.add_item(pokemon_data.species.ability2.name)
	if pokemon_data.species.ability3:
		ability_selector.add_item(pokemon_data.species.ability3.name)
	set_ability(pokemon_data)

func set_tera_type(type_name:String):
	var index = -1
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
	$"Tera/TeraSelect".select(index)

func set_training_values(pokemon_data: PokemonData):
	var container_node = $"Stats"
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
	var increase_selector = $"NatureSelector/NatureIncrease"
	var reduced_selector = $"NatureSelector/NatureDecrease"
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

func set_ability(pokemon_data: PokemonData):
	var select_value = 0
	if pokemon_data.ability.name == ability_selector.get_item_text(1):
		select_value = 1
	if pokemon_data.ability.name == ability_selector.get_item_text(2):
		select_value = 2
	ability_selector.select(select_value)

func set_item(pokemon_data: PokemonData):
	if pokemon_data.item == null:
		item_selector.select("")
	else:
		item_selector.select(pokemon_data.item.name)

func set_moves(pokemon_data: PokemonData):
	if pokemon_data.move1 == null:
		move_selector1.select("")
	else:
		move_selector1.select(pokemon_data.move1.name)
		
	if pokemon_data.move2 == null:
		move_selector2.select("")
	else:
		move_selector2.select(pokemon_data.move2.name)
	
	if pokemon_data.move3 == null:
		move_selector3.select("")
	else:
		move_selector3.select(pokemon_data.move3.name)
	
	if pokemon_data.move4 == null:
		move_selector4.select("")
	else:
		move_selector4.select(pokemon_data.move4.name)


#Signal Reaktions
func _on_set_select_item_selected(index):
	var pokemon_set: PokemonData = set_selector.get_item_metadata(index)
	if pokemon_set:
		set_pokemon_data(pokemon_set)
	else:
		clear_set()

func _on_stats_gui_input(event):
	var container_node = $"Stats"
	var remaining_ev_total = 508

	remaining_ev_total -= container_node.get_node("HpEv").value
	remaining_ev_total -= container_node.get_node("AtkEv").value
	remaining_ev_total -= container_node.get_node("DefEv").value
	remaining_ev_total -= container_node.get_node("SpaEv").value
	remaining_ev_total -= container_node.get_node("SpdEv").value
	remaining_ev_total -= container_node.get_node("SpeEv").value

	$"NatureSelector/EVCountLabel".text = "%s" % remaining_ev_total

func _on_species_item_selected(name):
	clear_set()
	set_selector.clear()
	set_selector.add_item("New Set", 0)
	set_selector.set_item_metadata(0, null)
	ability_selector.clear()
	
	for species in pokemon_list:
		if name in species.name:
			emit_signal("pokemon_selected", species)
			set_tera_type(species.main_type)
			if species.ability1:
				ability_selector.add_item(species.ability1.name)
			if species.ability2:
				ability_selector.add_item(species.ability2.name)
			if species.ability3:
				ability_selector.add_item(species.ability3.name)
	
	ability_selector.select(0)
	
	var id = 1
	for pokemon_set in get_pokemon_set_from_species(name):
		set_selector.add_item(get_format(pokemon_set.format) +" - "+ pokemon_set.name, id)
		set_selector.set_item_metadata(id, pokemon_set)
		id += 1
