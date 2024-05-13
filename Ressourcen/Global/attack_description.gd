extends Node

func create_description(context: AttackContext):
	var attacker_boost = get_attack_boost(context)
	var attacker_training = get_attacker_training(context)
	var attacker_item = get_attacker_item(context)
	var attacker_ability = get_attacker_ability(context)
	var offensive_ruin = get_offensive_ruin(context)
	var attacker_tera = get_attacker_tera(context)
	var attacker_name = context.attacker.data.species.name + " "
	var attacker = attacker_boost + attacker_training + attacker_item + attacker_tera + attacker_name
	
	var helping_hand = get_helping_hand(context)
	var attack_name = context.get_move().name + " "
	var attack_extra = get_extra_attack_info(context)
	var attack = helping_hand + attack_name + attack_extra
	
	var defender_boost = get_defense_boost(context)
	var defender_training = get_defender_training(context)
	var defender_item = get_defender_item(context)
	var defender_tera = get_defender_tera(context)
	var defender_name = context.defender.data.species.name + " "
	var defender = defender_boost + defender_training + defender_item + defender_tera + defender_name
	
	var screen = get_screen(context)
	var friend_guard = get_friend_guard(context)
	var terrain = get_terrain(context)
	var weather = get_weather(context)
	var environment = screen + friend_guard + terrain + weather
	
	var description = attacker + attack + "vs. " + defender + environment
	return description

func get_attack_boost(context: AttackContext) -> String:
	var boost_value = 0
	match(get_used_attack_stat(context)):
		"Defense":
			boost_value = context.attacker.state.defense_stack
		"Attack":
			boost_value = context.attacker.state.attack_stack
		"Special Attack":
			boost_value = context.attacker.state.special_attack_stack
	
	if boost_value != 0:
		return str(boost_value) + " "
	
	return ""

func get_attacker_training(context: AttackContext) -> String:
	var data = context.attacker.data
	var text = ""
	var stat = ""
	var iv = 0
	match(get_used_attack_stat(context)):
		"Defense":
			stat = "Def"
			text = str(data.def_evs)
			iv = data.def_ivs
		"Attack":
			stat = "Atk"
			text = str(data.atk_evs)
			iv = data.atk_ivs
		"Special Attack":
			stat = "SpA"
			text = str(data.spa_evs)
			iv = data.spa_ivs
	
	if data.increased_stat == stat:
		text = text + "+"
	if data.reduced_stat == stat:
		text = text + "-"
	
	if iv != 31:
		text = text + " " + str(iv) + "IV"
	
	return text + " " + stat + " "

func get_attacker_item(context: AttackContext) -> String:
	var item = context.attacker.data.item
	match([item, context.get_move().category]):
		["Choice Band", "Physical"], ["Choice Specs", "Special"], ["Life Orb", _]:
			return item + " "
	match(context.get_move().type):
		"Normal":
			match(item):
				"Silk Scarf":
					return item + " "
		"Fighting": 
			match(item):
				"Fist Plate","Black Belt":
					return item + " "
		"Flying":
			match(item):
				"Sky Plate", "Sharp Beak":
					return item + " "
		"Poison":
			match(item):
				"Toxic Plate", "Poison Barb":
					return item + " "
		"Ground":
			match(item):
				"Earth Plate", "Soft Sand":
					return item + " "
		"Rock":
			match(item):
				"Stone Plate", "Hard Stone":
					return item + " "
		"Bug":
			match(item):
				"Insect Plate", "Silver Powder":
					return item + " "
		"Ghost":
			match(item):
				"Spooky Plate", "Spell Tag":
					return item + " "
		"Steel":
			match(item):
				"Iron Plate", "Metal Coat":
					return item + " "
		"Fire":
			match(item):
				"Flame Plate", "Charcoal":
					return item + " "
		"Grass":
			match(item):
				"Meadow Plate", "Miracle Seed":
					return item + " "
		"Electric":
			match(item):
				"Zap Plate", "Magnet":
					return item + " "
		"Psychic":
			match(item):
				"Mind Plate", "Twisted Spoon":
					return item + " "
		"Ice":
			match(item):
				"Icicle Plate", "Never-Melt Ice":
					return item + " "
		"Dragon":
			match(item):
				"Draco Plate", "Dragon Fang":
					return item + " "
		"Dark":
			match(item):
				"Dread Plate", "Black Glasses":
					return item + " "
		"Fairy":
			match(item):
				"Pixie Plate", "Fairy Feather":
					return item + " "
			
	return ""

func get_attacker_ability(context: AttackContext) -> String:
	var ability = context.attacker.data.ability.name
	var data = context.attacker.data
	if ability == "Adaptability":
		if context.attacker.state.terracrystalized and context.get_move().type == data.tera_type:
			return ability + " "
		elif context.get_move().type == data.species.main_type or context.get_move().type == data.species.secondary_type:
			return ability + " "
	if ability == "Mold Breaker":
		match([context.get_move().type, context.defender.data.ability]):
			["Ground", "Levitate"], ["Ground", "Earth Eater"], ["Fire", "Flash Fire"]:
				return ability + " "
			["Water", "Dry Skin"], ["Water", "Water Absorb"], ["Water", "Storm Drain"]:
				return ability + " "
			["Electric", "Lightning Rod"], ["Electric", "Volt Absorb"], ["Electric", "Motor Drive"]:
				return ability + " "
			["Grass", "Sap Sipper"]:
				return ability + " "
	
	if context.attacker.state.health <= 100/3:
		match([ability, context.get_move().type]):
			["Overgrow", "Grass"], ["Blaze", "Fire"], ["Torrent", "Water"]:
				return ability + " "
	
	match(ability):
		"Protosynthesis", "Quark Drive":
			match(context.get_move().category):
				"Physical":
					if context.paraboost == "Atk":
						return ability + " "
				"Special":
					if context.paraboost == "SpA":
						return ability + " "
	
	return ""

func get_offensive_ruin(context: AttackContext) -> String:
	match([get_used_defense_stat(context), context.ruin_sword, context.ruin_sword]):
		["Defense", true, _] when context.defender.data.ability.name != "Sword of Ruin":
			return "Sword of Ruin "
		["Special Defense", _, true] when context.defender.data.ability.name != "Beads of Ruin":
			return "Beads of Ruin "
	return ""

func get_attacker_tera(context: AttackContext) -> String:
	if context.attacker.state.terracrystalized:
		return "Tera-" + context.attacker.data.tera_type + " "
	
	return ""

func get_helping_hand(context: AttackContext) -> String:
	if context.helping_hand:
		return "Helping Hand "
	return ""

func get_extra_attack_info(context: AttackContext) -> String:
	match(context.get_move().name):
		"Heavy Slam", "Heat Crash":
			return "(" + str(damage_calculation.get_heavy_slam_power(context.attacker.data.species.weight, context.defender.data.species.weight)) + " BP) "
		"Low Kick", "Grass Knot":
			return "(" + str(damage_calculation.get_low_kick_power(context.defender.data.species.weight)) + " BP) "
		"Expanding Force":
			if context.terrain == "Psychic":
				return "(120 BP) "
		"Rising Voltage":
			if context.terrain == "Electric":
				return "(140 BP) "
		"Misty Explosion":
			if context.terrain == "Misty":
				return "(150 BP) "
	return ""

func get_defense_boost(context: AttackContext) -> String:
	var boost_value = 0
	match(get_used_defense_stat(context)):
		"Defense":
			boost_value = context.attacker.state.defense_stack
		"Special Defense":
			boost_value = context.attacker.state.special_defense_stack
	
	if boost_value != 0:
		return str(boost_value) + " "
	
	return ""

func get_defender_training(context: AttackContext) -> String:
	var data = context.defender.data
	var defense = ""
	var stat = ""
	var iv = 0
	match(get_used_defense_stat(context)):
		"Defense":
			stat = "Def"
			defense = str(data.def_evs)
			iv = data.def_ivs
		"Special Defense":
			stat = "SpD"
			defense = str(data.spd_evs)
			iv = data.spd_ivs
	
	if data.increased_stat == stat:
		defense = defense + "+"
	if data.reduced_stat == stat:
		defense = defense + "-"
	
	if iv != 31:
		defense = defense + " " + str(iv) + "IV"
	
	var hp = str(data.hp_evs)
	
	if data.hp_ivs != 31:
		hp = "%s %sIV" % [hp, data.hp_ivs]
	
	return "%s HP / %s %s " % [hp, defense, stat]

func get_defender_item(context: AttackContext) -> String:
	var item = context.defender.data.item
	match([item, context.get_move().category]):
		["Assault Vest", "Special"]:
			return item + " "
	
	var type_matchup = damage_calculation.checkTypeMatchup(context.get_move(),context.defender.get_typing())
	match(context.get_move().type):
		"Normal":
			match(item):
				"Chilan Berry":
					return item + " "
		"Fighting" when type_matchup > 0: 
			match(item):
				"Chople Berry":
					return item + " "
		"Flying" when type_matchup > 0:
			match(item):
				"Coba Berry":
					return item + " "
		"Poison" when type_matchup > 0:
			match(item):
				"Kebia Berry":
					return item + " "
		"Ground" when type_matchup > 0:
			match(item):
				"Shuca Berry":
					return item + " "
		"Rock" when type_matchup > 0:
			match(item):
				"Charti Berry":
					return item + " "
		"Bug" when type_matchup > 0:
			match(item):
				"Tanga Berry":
					return item + " "
		"Ghost" when type_matchup > 0:
			match(item):
				"Kasib Berry":
					return item + " "
		"Steel" when type_matchup > 0:
			match(item):
				"Babiri Berry":
					return item + " "
		"Fire" when type_matchup > 0:
			match(item):
				"Occa Berry":
					return item + " "
		"Grass" when type_matchup > 0:
			match(item):
				"Rindo Berry":
					return item + " "
		"Electric" when type_matchup > 0:
			match(item):
				"Wacan Berry":
					return item + " "
		"Psychic" when type_matchup > 0:
			match(item):
				"Payapa Berry":
					return item + " "
		"Ice" when type_matchup > 0:
			match(item):
				"Yache Berry":
					return item + " "
		"Dragon" when type_matchup > 0:
			match(item):
				"Haban Berry":
					return item + " "
		"Dark" when type_matchup > 0:
			match(item):
				"Colbur Berry":
					return item + " "
		"Fairy" when type_matchup > 0:
			match(item):
				"Roseli Berry":
					return item + " "
	
	return ""

func get_defender_ability(context: AttackContext) -> String:
	var ability = context.attacker.data.ability.name
	var data = context.attacker.data

	match([context.get_move().type, context.defender.data.ability]):
		["Ground", "Levitate"], ["Ground", "Earth Eater"], ["Fire", "Flash Fire"]:
			return ability + " "
		["Water", "Dry Skin"], ["Water", "Water Absorb"], ["Water", "Storm Drain"]:
			return ability + " "
		["Electric", "Lightning Rod"], ["Electric", "Volt Absorb"], ["Electric", "Motor Drive"]:
			return ability + " "
		["Grass", "Sap Sipper"]:
			return ability + " "
	
	match(ability):
		"Protosynthesis", "Quark Drive":
			match(get_used_defense_stat(context)):
				"Defense":
					if context.paraboost == "Def":
						return ability + " "
				"Special Defense":
					if context.paraboost == "SpD":
						return ability + " "
	
	return ""

func get_defensive_ruin(context: AttackContext) -> String:
	match([context.get_move().category, context.ruin_tablets, context.ruin_vessel]):
		["Physical", true, _] when context.attacker.data.ability.name != "Tablets of Ruin":
			return "Tablets of Ruin "
		["Special", _, true] when context.attacker.data.ability.name != "Vessel of Ruin":
			return "Vessel of Ruin "
	return ""

func get_defender_tera(context: AttackContext) -> String:
	if context.defender.state.terracrystalized:
		return "Tera-" + context.defender.data.tera_type + " "
	
	return ""

func get_screen(context: AttackContext) -> String:
	if context.screen != "":
		return "through %s " % context.screen
	return "" 

func get_friend_guard(context: AttackContext) -> String:
	if context.friend_guard:
		return "with Friend Guard "
	return ""

func get_terrain(context: AttackContext) -> String:
	var terrain = ""
	if damage_calculation.isPokemonGrounded(context.attacker):
		match([context.terrain, context.get_move().type]):
			["Grassy", "Grass"]:
				terrain = context.terrain
			["Psychic", "Psychic"]:
				terrain = context.terrain
			["Electric", "Electric"]:
				terrain = context.terrain
	
	if damage_calculation.isPokemonGrounded(context.defender):
		match([context.terrain, context.get_move().type]):
			["Misty", "Dragon"]:
				terrain = context.terrain
	
	match(context.get_move().name):
		"Earthquake", "Bulldoze", "Magnitude":
			terrain = context.terrain
	
	if terrain != "":
		return "in %s Terrain" % terrain
	return ""

func get_weather(context: AttackContext) -> String:
	var weather = ""
	match([context.weather, context.get_move().type]):
		["Sun", "Fire"], ["Sun", "Water"], ["Rain", "Fire"], ["Rain", "Water"]:
			weather = context.weather
	match([context.weather, get_used_defense_stat(context)]):
		["Sand", "Special Defense"], ["Snow", "Defense"]:
			weather = context.weather
	if context.get_move().name == "Weather Ball":
		if context.weather == "Sun" or context.weather == "Rain":
			weather = context.weather
	
	if weather != "":
		return "in %s " % context.weather
	return ""

func get_used_attack_stat(context: AttackContext) -> String:
	if context.get_move().name == "Body Press":
		return "Defense"
	elif context.get_move().category == "Physical":
		return "Attack"
	elif context.get_move().category == "Special":
		return "Special Attack"
	return ""

func get_used_defense_stat(context: AttackContext) -> String:
	match(context.get_move().name):
		"Psyshock", "Psystrike", "Secret Sword":
			return "Defense"
	
	match (context.get_move().category):
		"Physical":
			return "Defense"
		"Special":
			return "Special Defense"
	return ""
