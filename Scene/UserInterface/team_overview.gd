extends Control

@onready var team_select = $MarginContainer/VBoxContainer/CoreUI/Left/TeamSelect
@onready var physical_list = $MarginContainer/VBoxContainer/CoreUI/Middle/PhysicalScroll/MoveList
@onready var special_list = $MarginContainer/VBoxContainer/CoreUI/Middle/SpecialScroll/MoveList
@onready var defender = Pokemon.new()

@onready var team_move_item_scene = preload("res://Scene/UserInterface/SubScenes/team_move_item.tscn")

func _ready() -> void:
	defender.state = PokemonState.new()
	defender.data = PokemonData.new()
	defender.data.species = Species.new()
	defender.data.ability = Ability.new()
	defender.data.item = Item.new()

#Loading
func startup() -> void:
	show()

#Interface
func update_middle():
	clear_middle_selection()
	var context = AttackContext.new()
	context.damage_roll = 15
	var team_index = 0
	var physical_move_list: Array[TeamMoveItem]
	var special_move_list: Array[TeamMoveItem]
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
						"Physical":
							for attack_variant in get_attack_variants(context):
								var team_move_item = team_move_item_scene.instantiate()
								team_move_item.modulate = get_member_color(team_index)
								team_move_item.load_attack(attack_variant)
								physical_move_list.append(team_move_item)
						"Special":
							var test_list = get_attack_variants(context) #Debug
							for attack_variant in test_list:
								
								var team_move_item = team_move_item_scene.instantiate()
								team_move_item.modulate = get_member_color(team_index)
								team_move_item.load_attack(attack_variant)
								if attack_variant.get_move().name == "Tera Blast" and attack_variant.attacker.state.terracrystalized:
									if attack_variant.attacker.get_field_atk() > attack_variant.attacker.get_field_spa():
										physical_move_list.append(team_move_item)
								special_move_list.append(team_move_item)
		team_index += 1
	physical_move_list.sort_custom(func(a,b): return a.value > b.value)
	special_move_list.sort_custom(func(a,b): return a.value > b.value)
	
	for team_move_item in physical_move_list:
		physical_list.add_child(team_move_item)
	for team_move_item in special_move_list:
		special_list.add_child(team_move_item)

func clear_middle_selection():
	for child in physical_list.get_children():
		physical_list.remove_child(child)
		child.queue_free()
	for child in special_list.get_children():
		special_list.remove_child(child)
		child.queue_free()

func clear() -> void:
	pass #TODO

#Getter
func get_team_data() -> Array[PokemonData]:
	return team_select.get_team().team_members

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
	
	#Low Kick, Grass Knot
	match move.name:
		"Low Kick", "Grass Knot":
			var new_context : AttackContext= context.duplicate(true)
			new_context.defender.data.species.weight = 1
			context_list.append(new_context)
			new_context = context.duplicate(true)
			new_context.defender.data.species.weight = 10
			context_list.append(new_context)
			new_context = context.duplicate(true)
			new_context.defender.data.species.weight = 25
			context_list.append(new_context)
			new_context = context.duplicate(true)
			new_context.defender.data.species.weight = 100
			context_list.append(new_context)
			new_context = context.duplicate(true)
			new_context.defender.data.species.weight = 200
			context_list.append(new_context)
	
	#Flame Orb
	if context.attacker.data.item.name == "Flame Orb" and move.category == "Physical":
		var new_context : AttackContext = context.duplicate(true)
		new_context.attacker.state.condition = "Burn"
		context_list.append(new_context)
	
	
	#Sonne
	if move.type == "Fire" or move.type == "Water" or move.name == "Weather Ball":
		if has_team_ability("Drought") or has_team_ability("Orichalcum Pulse") or has_team_move("Sunny Day"):
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
		if move.type == context.attacker.data.tera_type or move.name == "Tera Blast" or context.attacker.data.tera_type == "Stellar":
			var new_context = variant.duplicate(true)
			new_context.attacker.state.terracrystalized = true
			if new_context.attacker.data.tera_type == "Stellar":
				new_context.is_stellar_boosted = true
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

#Checks
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

#Utility
func sort_items(container: Container):
	var list = container.get_children()
	list.sort_custom(func(a,b): return a.value > b.value)
	var index = 0
	for item in list:
		container.move_child(item, index)
		index += 1

func create_variants(context_list: Array[AttackContext], context_change: Callable, subresources = false):
	var context_variants : Array[AttackContext]
	for variant in context_list:
		var new_context: AttackContext = variant.duplicate(subresources)
		context_change.call(new_context)
		context_variants.append(new_context)
	context_list.append_array(context_variants)

#Signal Reactions
func _on_team_select_team_selected(team: TeamData) -> void:
	update_middle()
	
	for item in $MarginContainer/VBoxContainer/CoreUI/Right/Defense.get_children():
		item.set_value_team(team)
	sort_items($MarginContainer/VBoxContainer/CoreUI/Right/Defense)
	
	for item in $MarginContainer/VBoxContainer/CoreUI/Right/HP.get_children():
		item.set_value_team(team)
	sort_items($MarginContainer/VBoxContainer/CoreUI/Right/HP)
	
	for item in $MarginContainer/VBoxContainer/CoreUI/Right/Speed.get_children():
		item.set_value_team(team)
	sort_items($MarginContainer/VBoxContainer/CoreUI/Right/Speed)

func _on_back_pressed() -> void:
	hide()
	clear()
