extends PanelContainer
class_name MoveCalcItem

func create_description(context: AttackContext):
	var attacker_boost = get_attack_boost(context)
	var attacker_training = get_attacker_training(context)
	var attacker_item = get_attacker_item(context)
	var attacker_ability = get_attacker_ability(context)
	var attacker_tera = get_attacker_tera(context)
	var attacker_name = context.attacker.data.species.name + " "
	var attacker = attacker_boost + attacker_training + attacker_item + attacker_tera + attacker_name
	
	var attack_booster = ""
	var attack_name = ""
	var attack_extra = ""
	var attack = attack_booster + attack_name + attack_extra
	
	var defender_boost = ""
	var defender_training = ""
	var defender_item = ""
	var defender_tera = ""
	var defender_name = ""
	var defender = defender_boost + defender_training + defender_item + defender_tera + defender_name
	
	var screen = ""
	var friend_guard = ""
	var terrain = ""
	var weather = ""
	var environment = screen + friend_guard + terrain + weather
	
	var description = attacker + attack + " vs. " + defender + environment
	$MarginContainer/HBoxContainer/Description.text = description

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
			match(get_used_attack_stat(context)):
				"Defense":
					if context.paraboost == "Def":
						return ability + " "
				"Attack":
					if context.paraboost == "Atk":
						return ability + " "
				"Special Attack":
					if context.paraboost == "SpA":
						return ability + " "
	
	return ""

func get_attacker_tera(context: AttackContext) -> String:
	if context.attacker.state.terracrystalized:
		return "Tera-" + context.attacker.data.tera_type + " "
	
	return ""

func get_used_attack_stat(context: AttackContext) -> String:
	if context.get_move().name == "Body Press":
		return "Defense"
	elif context.get_move().category == "Physical":
		return "Attack"
	elif context.get_move().category == "Special":
		return "Special Attack"
	return ""
