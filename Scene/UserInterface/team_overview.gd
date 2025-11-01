extends Control

@onready var team_select = $MarginContainer/VBoxContainer/CoreUI/Left/TeamSelect
@onready var move_list = $MarginContainer/VBoxContainer/CoreUI/Middle/MiddleScroll/MoveList
@onready var defender = Pokemon.new()

@onready var team_move_item_scene = preload("res://Scene/UserInterface/SubScenes/team_move_item.tscn")

func _ready() -> void:
	defender.state = PokemonState.new()
	defender.data = PokemonData.new()
	defender.data.species = Species.new()
	defender.data.ability = Ability.new()
	defender.data.item = Item.new()

func update_middle():
	clear_middle_selection()
	var context = AttackContext.new()
	context.damage_roll = 15
	var team_index = 0
	var team_move_list: Array[TeamMoveItem]
	for team_member_data: PokemonData in get_team_data():
	
		var test_pokemon = Pokemon.new()
		test_pokemon.state = PokemonState.new()
		test_pokemon.data = team_member_data
		context.attacker = test_pokemon
		context.defender = defender
		
		for move_value in range(1,5):
				context.used_attack = move_value
				if context.get_move():
					match(context.get_move().category):
						"Physical", "Special":
							for attack_variant in get_attack_variants(context):
								var team_move_item = team_move_item_scene.instantiate()
								team_move_item.modulate = get_member_color(team_index)
								team_move_item.load_attack(attack_variant)
								team_move_list.append(team_move_item)
		team_index += 1
	team_move_list.sort_custom(func(a,b): return a.value > b.value)
	
	for team_move_item in team_move_list:
		move_list.add_child(team_move_item)

func clear_middle_selection():
	for child in move_list.get_children():
		move_list.remove_child(child)
		child.queue_free()

func get_team_data() -> Array[PokemonData]:
	return team_select.get_team().team_members

func sort_items(container: Container):
	var list = container.get_children()
	list.sort_custom(func(a,b): return a.value > b.value)
	var index = 0
	for item in list:
		container.move_child(item, index)
		index += 1
	

func _on_team_select_team_selected(team: TeamData) -> void:
	update_middle()
	
	for item in $MarginContainer/VBoxContainer/CoreUI/Right/Scroll/VBoxContainer.get_children():
		item.set_value_team(team)
	sort_items($MarginContainer/VBoxContainer/CoreUI/Right/Scroll/VBoxContainer)
	
	for item in $MarginContainer/VBoxContainer/CoreUI/Right/VBoxContainer.get_children():
		item.set_value_team(team)
	sort_items($MarginContainer/VBoxContainer/CoreUI/Right/VBoxContainer)

func get_member_color(index : int) -> Color:
	match(index):
		1:
			return Color("57af76")
		2:
			return Color("ed6196")
		3:
			return Color("669ae6")
		4:
			return Color("da7e4b")
		5:
			return Color("af7ceb")
		_:
			return Color("999999")

func get_attack_variants(context: AttackContext) -> Array[AttackContext]:
	var context_list : Array[AttackContext]
	context_list.append(context)
	var move : Move = context.get_move()
	
	#Flame Orb
	if context.attacker.data.item.name == "Flame Orb" and move.category == "Physical":
		var new_context : AttackContext = context.duplicate(true)
		new_context.attacker.state.condition = "Burn"
		context_list.append(new_context)
	
	
	#Sonne
	if move.type == "Fire" or move.type == "Water" or move.name == "Weather Ball":
		if has_team_ability("Drought") or has_team_ability("Orichalcum Pulse") or has_team_move("Sunndy Day"):
			var new_context = context.duplicate(false)
			new_context.weather = "Sun"
			context_list.append(new_context)
	
	#Regen
	if move.type == "Fire" or move.type == "Water" or move.name == "Weather Ball":
		if has_team_ability("Drizzle") or has_team_move("Rain Dance"):
			var new_context = context.duplicate(false)
			new_context.weather = "Rain"
			context_list.append(new_context)
	
	#Terrain
	if move.type == "Grass":
		if has_team_ability("Grassy Surge") or has_team_move("Grassy Terrain"):
			var new_context = context.duplicate(false)
			new_context.terrain = "Grassy"
			context_list.append(new_context)
	
	if move.type == "Electric":
		if has_team_ability("Electric Surge") or has_team_move("Electric Terrain"):
			var new_context = context.duplicate(false)
			new_context.terrain = "Electric"
			context_list.append(new_context)
	
	if move.type == "Psychic":
		if has_team_ability("Psychic Surge") or has_team_move("Psychic Terrain"):
			var new_context = context.duplicate(false)
			new_context.terrain = "Psychic"
			context_list.append(new_context)
			if move.name == "Expanding Force":
				new_context = new_context.duplicate()
				new_context.is_spread = true
				context_list.append(new_context)
	
	if move.type == "Dragon":
		if has_team_ability("Misty Surge") or has_team_move("Misty Terrain"):
			var new_context = context.duplicate(false)
			new_context.terrain = "Misty"
			context_list.append(new_context)
	
	#Spread
	if move.targeting == "Enemies" or move.targeting == "All":
		create_variants(context_list, func(context: AttackContext):
			context.is_spread = true)
	
	#Tera
	var tera_variants : Array[AttackContext]
	for variant in context_list:
		if variant.get_move().type == context.attacker.data.tera_type:
			var new_context = variant.duplicate(true)
			new_context.attacker.state.terracrystalized = true
			tera_variants.append(new_context)
	context_list = context_list + tera_variants
	
	#Support Options
	if has_partner_move("Helping Hand", context.attacker.data):
		create_variants(context_list, func(context: AttackContext):
			context.helping_hand = true)
	
	if has_partner_move("Coaching", context.attacker.data) and context.get_move().category == "Physical":
		create_variants(context_list, func(context: AttackContext):
			context.attacker.state.attack_stack += 1
			context.attacker.state.defense_stack += 1
			, true)
	
	#Setup Options
	if has_move("Quiver Dance", context.attacker.data) and context.get_move().category == "Special":
		create_variants(context_list, func (context: AttackContext): 
			context.attacker.state.special_attack_stack +=1, true)
	
	if has_move("Swords Dance", context.attacker.data):
		create_variants(context_list, func(context: AttackContext):
			context.attacker.state.attack_stack += 2, true)
		
	return context_list

func has_team_ability(name: String) -> bool:
	for team_member in get_team_data():
		if team_member.ability.name == name:
			return true
	return false

func has_team_move(name: String) -> bool:
	for team_member in get_team_data():
		if team_member.move1.name == name:
			return true
		if team_member.move2.name == name:
			return true
		if team_member.move3.name == name:
			return true
		if team_member.move4.name == name:
			return true
	return false

func has_partner_move(name: String, pokemon_data: PokemonData) -> bool:
	var team_members: Array = get_team_data().duplicate()
	team_members.erase(pokemon_data)
	for team_member in team_members:
		if team_member.move1.name == name:
			return true
		if team_member.move2.name == name:
			return true
		if team_member.move3.name == name:
			return true
		if team_member.move4.name == name:
			return true
	return false

func has_move(name: String, pokemon_data: PokemonData):
	if pokemon_data.move1.name == name:
		return true
	if pokemon_data.move2.name == name:
		return true
	if pokemon_data.move3.name == name:
		return true
	if pokemon_data.move4.name == name:
		return true
	return false

func create_variants(context_list: Array[AttackContext], context_change: Callable, subresources = false):
	var context_variants : Array[AttackContext]
	for variant in context_list:
		var new_context: AttackContext = variant.duplicate(subresources)
		context_change.call(new_context)
		context_variants.append(new_context)
	context_list.append_array(context_variants)
