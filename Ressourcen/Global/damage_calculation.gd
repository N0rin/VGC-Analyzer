extends Node

const SPREAD = 3072
const WEATHER_BOOST = 6144
const WEATHER_DEBUFF = 2048

enum STEP{BasePower, Attack, Defense, General, Final}
enum CAT{Extra, Weather, Terrain, StatStage, Screen, Persistent}

func pokeRound(value: float) -> int:
	var remainder = value - floor(value)
	if remainder == 0.5:
		return floori(value)
	return roundi(value)

func apply_modifier(value : float, modifier : float) -> int:
	return pokeRound(value * (modifier / 4096) )

func combine_modifier(old_value : float, new_modifier : float) -> int:
	return roundi((old_value * new_modifier) / 4096)

func calculate_base_damage(base_power: float, attack: float, defense: float, level: float = 50):
	return floor(floor(floor( (2 * level) /5 + 2) * base_power * attack /defense) /50) +2

func calculate_base_power(context: AttackContext):
	var move = context.get_move()
	
	var modifier_value:float = 4096
	var move_power:float = move.base_damage
	
	match(move.name):
		"Heavy Slam", "Heat Crash":
			move_power = get_heavy_slam_power(context.attacker.get_weight(), context.defender.get_weight())
		"Low Kick", "Grass Knot":
			move_power == get_low_kick_power(context.defender.get_weight())
	
	#Type-Boost-Items
	var item = context.attacker.data.item.name
	match(context.get_move().type):
		"Normal":
			match(item):
				"Silk Scarf":
					modifier_value = combine_modifier(modifier_value, 4915)
		"Fighting": 
			match(item):
				"Fist Plate","Black Belt":
					modifier_value = combine_modifier(modifier_value, 4915)
		"Flying":
			match(item):
				"Sky Plate", "Sharp Beak":
					modifier_value = combine_modifier(modifier_value, 4915)
		"Poison":
			match(item):
				"Toxic Plate", "Poison Barb":
					modifier_value = combine_modifier(modifier_value, 4915)
		"Ground":
			match(item):
				"Earth Plate", "Soft Sand":
					modifier_value = combine_modifier(modifier_value, 4915)
		"Rock":
			match(item):
				"Stone Plate", "Hard Stone":
					modifier_value = combine_modifier(modifier_value, 4915)
		"Bug":
			match(item):
				"Insect Plate", "Silver Powder":
					modifier_value = combine_modifier(modifier_value, 4915)
		"Ghost":
			match(item):
				"Spooky Plate", "Spell Tag":
					modifier_value = combine_modifier(modifier_value, 4915)
		"Steel":
			match(item):
				"Iron Plate", "Metal Coat":
					modifier_value = combine_modifier(modifier_value, 4915)
		"Fire":
			match(item):
				"Flame Plate", "Charcoal":
					modifier_value = combine_modifier(modifier_value, 4915)
		"Grass":
			match(item):
				"Meadow Plate", "Miracle Seed":
					modifier_value = combine_modifier(modifier_value, 4915)
		"Electric":
			match(item):
				"Zap Plate", "Magnet":
					modifier_value = combine_modifier(modifier_value, 4915)
		"Psychic":
			match(item):
				"Mind Plate", "Twisted Spoon":
					modifier_value = combine_modifier(modifier_value, 4915)
		"Ice":
			match(item):
				"Icicle Plate", "Never-Melt Ice":
					modifier_value = combine_modifier(modifier_value, 4915)
		"Dragon":
			match(item):
				"Draco Plate", "Dragon Fang":
					modifier_value = combine_modifier(modifier_value, 4915)
		"Dark":
			match(item):
				"Dread Plate", "Black Glasses":
					modifier_value = combine_modifier(modifier_value, 4915)
		"Fairy":
			match(item):
				"Pixie Plate", "Fairy Feather":
					modifier_value = combine_modifier(modifier_value, 4915)
		"Water":
			match(item):
				"Splash Plate", "Mystic Water":
					modifier_value = combine_modifier(modifier_value, 4915)
	
	#Helping Hand
	if context.helping_hand:
		modifier_value = combine_modifier(modifier_value, 6144)
	
	#Terrains
	match([context.terrain, context.get_move().name]):
		["Grassy", "Bulldoze"], ["Grassy", "Earthquake"], ["Grassy", "Magnitude"]:
			modifier_value = combine_modifier(modifier_value, 2048)
	
	if context.defender.is_grounded():
		match (context.terrain):
			"Misty":
				if move.type == "Dragon":
					modifier_value = combine_modifier(modifier_value, 2048)
	if context.attacker.is_grounded():
		match(context.terrain):
			"Psychic":
				if move.name == "Expanding Force":
					move_power = 120
				if move.type == "Psychic":
					modifier_value = combine_modifier(modifier_value, 5325)
			"Grassy":
				if move.type == "Grass":
					modifier_value = combine_modifier(modifier_value, 5325)
			"Electric":
				if move.type == "Electric":
					modifier_value = combine_modifier(modifier_value, 5325)
	
	return apply_modifier(move_power, modifier_value)

func calculate_attack_value(context: AttackContext) -> int:
	var attack = 1
	var attack_stack = 0
	var is_special = false
	
	if context.get_move().category == "Special":
		is_special = true
	
	match([is_special, context.get_move().name]):
		[true, _]:
			attack = context.attacker.data.get_spa_value()
			attack_stack = context.attacker.state.special_attack_stack
		[_, "Foul Play"]:
			attack = context.defender.data.get_atk_value()
			attack_stack = context.defender.state.attack_stack
		[_, "Body Press"]:
			attack = context.attacker.data.get_def_value()
			attack_stack = context.attacker.state.defense_stack
		[false, _]:
			attack = context.attacker.data.get_atk_value()
			attack_stack = context.attacker.state.attack_stack
	
	if context.defender.data.ability.name == "Unaware":
		attack_stack = 0
	if context.critical_hit and attack_stack < 0:
		attack_stack = 0
	
	if attack_stack > 0:
		attack = floor(attack * (2 + attack_stack)/2 ) 
	if attack_stack < 0:
		attack = floor(attack * 2/(-attack_stack+2) )
	
	var attack_modifier = 4096
	#Ruin Abilities
	match([context.ruin_sword, context.ruin_vessel, is_special]):
			[true, _, false], [_, true, true]:
				attack_modifier = combine_modifier(attack_modifier, 3072)
	#Offensive Abilities
	match(context.attacker.data.ability.name):
		"Overgrow" when context.get_move().type == "Grass":
			if context.attacker.get_current_hp() <= floor(context.attacker.data.get_hp_value() /3):
				attack_modifier = combine_modifier(attack_modifier, 6144)
		"Blaze" when context.get_move().type == "Fire":
			if context.attacker.get_current_hp() <= floor(context.attacker.data.get_hp_value() /3):
				attack_modifier = combine_modifier(attack_modifier, 6144)
		"Torrent" when context.get_move().type == "Water":
			if context.attacker.get_current_hp() <= floor(context.attacker.data.get_hp_value() /3):
				attack_modifier = combine_modifier(attack_modifier, 6144)
	#Choice Items
	match([context.attacker.data.item.name, is_special]):
			["Choice Band", false], ["Choice Specs", true]:
				attack_modifier = combine_modifier(attack_modifier, 6144)
	
	return apply_modifier(attack, attack_modifier)

func calculate_defense_value(context: AttackContext) -> int:
	var defense = 1
	var defense_stack = 0
	
	var is_special = false
	if context.get_move().category == "Special":
		is_special = true
	match (context.get_move().name):
		"Psyshock", "Psystrike", "Secret Sword":
			is_special = false
	
	match(is_special):
		false:
			defense = context.defender.data.get_def_value()
			defense_stack = context.defender.state.defense_stack
		true:
			defense = context.defender.data.get_spd_value()
			defense_stack = context.defender.state.special_defense_stack
	
	if context.attacker.data.ability.name == "Unaware":
		defense_stack = 0
	if context.get_move().name == "Sacred Sword":
		defense_stack = 0
	if context.critical_hit and defense_stack > 0:
		defense_stack = 0
	
	if defense_stack > 0:
		defense = floor(defense * (2 + defense_stack)/2 ) 
	if defense_stack < 0:
		defense = floor(defense * 2/(-defense_stack+2) )
	
	#Weather
	match([context.weather, is_special, context.defender.get_typing()]):
		["Sand", true, ["Rock", _]],["Sand", true, [_, "Rock"]]:
			defense = apply_modifier(defense, 6144)
		["Snow", false, ["Ice", _]],["Snow", false, [_, "Ice"]]:
			defense = apply_modifier(defense, 6144)
	
	var defense_modifier = 4096
	
	#Ruin Abilities
	match([context.ruin_tablets, context.ruin_beads, is_special]):
			[true, _, false], [_, true, true]:
				defense_modifier = combine_modifier(defense_modifier, 3072)
	
	#Items
	match([context.defender.data.item.name, is_special]):
		["Eviolite", _], ["Assault Vest", true]:
			defense_modifier = combine_modifier(defense_modifier, 6144)
	
	return apply_modifier(defense, defense_modifier) 

func calculate_final_modifier(context: AttackContext) -> int:
	var modifier_value = 4096
	
	match([context.screen, context.get_move().category]):
			["Aurora Veil", _], ["Reflector", "Physical"],["Light Screen", "Special"] when not context.critical_hit:
					modifier_value = combine_modifier(modifier_value, 2732)
	match(context.attacker.data.ability):
		"Neuroforce" when check_type_matchup(context.get_move(), context.defender.get_typing()) > 0:
			modifier_value = combine_modifier(modifier_value, 5120)
		"Sniper" when context.critical_hit:
			modifier_value = combine_modifier(modifier_value, 6144)
		"Tinted Lens" when check_type_matchup(context.get_move(), context.defender.get_typing()) < 0:
			modifier_value = combine_modifier(modifier_value, 8192)
	
	match(context.defender.data.ability.name):
		"Multiscale", "Shadow Shield" when context.defender.get_current_hp() == context.defender.data.get_hp_value():
			modifier_value = combine_modifier(modifier_value, 2048)
		"Fluffy" when context.get_move().makes_contact:
			modifier_value = combine_modifier(modifier_value, 2048)
	
	if context.friend_guard:
			modifier_value = combine_modifier(modifier_value, 3072)
	
	match(context.defender.data.ability.name):
		"Solid Rock", "Filter", "Prism Armor" when check_type_matchup(context.get_move(), context.defender.get_typing()) < 0:
			modifier_value = combine_modifier(modifier_value, 3072)
		"Fluffy" when context.get_move().type == "Fire":
			modifier_value = combine_modifier(modifier_value, 8192)
		
	match(context.attacker.data.item):
		"Expert Belt" when check_type_matchup(context.get_move(), context.defender.get_typing()) > 0:
			modifier_value = combine_modifier(modifier_value, 4915)
		"Life Orb":
			modifier_value = combine_modifier(modifier_value, 5324)
	
	var type_matchup = damage_calculation.check_type_matchup(context.get_move(),context.defender.get_typing())
	var item = context.defender.data.item.name
	match(context.get_move().type):
		"Normal":
			match(item):
				"Chilan Berry":
					modifier_value = combine_modifier(modifier_value, 2048)
		"Fighting" when type_matchup > 0: 
			match(item):
				"Chople Berry":
					modifier_value = combine_modifier(modifier_value, 2048)
		"Flying" when type_matchup > 0:
			match(item):
				"Coba Berry":
					modifier_value = combine_modifier(modifier_value, 2048)
		"Poison" when type_matchup > 0:
			match(item):
				"Kebia Berry":
					modifier_value = combine_modifier(modifier_value, 2048)
		"Ground" when type_matchup > 0:
			match(item):
				"Shuca Berry":
					modifier_value = combine_modifier(modifier_value, 2048)
		"Rock" when type_matchup > 0:
			match(item):
				"Charti Berry":
					modifier_value = combine_modifier(modifier_value, 2048)
		"Bug" when type_matchup > 0:
			match(item):
				"Tanga Berry":
					modifier_value = combine_modifier(modifier_value, 2048)
		"Ghost" when type_matchup > 0:
			match(item):
				"Kasib Berry":
					modifier_value = combine_modifier(modifier_value, 2048)
		"Steel" when type_matchup > 0:
			match(item):
				"Babiri Berry":
					modifier_value = combine_modifier(modifier_value, 2048)
		"Fire" when type_matchup > 0:
			match(item):
				"Occa Berry":
					modifier_value = combine_modifier(modifier_value, 2048)
		"Grass" when type_matchup > 0:
			match(item):
				"Rindo Berry":
					modifier_value = combine_modifier(modifier_value, 2048)
		"Electric" when type_matchup > 0:
			match(item):
				"Wacan Berry":
					modifier_value = combine_modifier(modifier_value, 2048)
		"Psychic" when type_matchup > 0:
			match(item):
				"Payapa Berry":
					modifier_value = combine_modifier(modifier_value, 2048)
		"Ice" when type_matchup > 0:
			match(item):
				"Yache Berry":
					modifier_value = combine_modifier(modifier_value, 2048)
		"Dragon" when type_matchup > 0:
			match(item):
				"Haban Berry":
					modifier_value = combine_modifier(modifier_value, 2048)
		"Dark" when type_matchup > 0:
			match(item):
				"Colbur Berry":
					modifier_value = combine_modifier(modifier_value, 2048)
		"Fairy" when type_matchup > 0:
			match(item):
				"Roseli Berry":
					modifier_value = combine_modifier(modifier_value, 2048)
		"Water" when type_matchup > 0:
			match(item):
				"Passho Berry":
					modifier_value = combine_modifier(modifier_value, 2048)
					
	return modifier_value

func calculate_complete_damage(context: AttackContext) -> int:
	var base_power = calculate_base_power(context)
	var attack = calculate_attack_value(context)
	var defense = calculate_defense_value(context)
	
	var damage:int = calculate_base_damage(base_power, attack, defense)
	
	#Spread Reduction
	if context.is_spread:
		damage = apply_modifier(damage, 3072)
	
	#Weather
	match([context.weather, context.get_move().type]):
			["Sun", "Fire"], ["Rain", "Water"]:
				damage = apply_modifier(damage, 6144)
			["Sun", "Water"], ["Rain", "Fire"]:
				damage = apply_modifier(damage, 2048)
	
	#Critical Hit
	if context.critical_hit:
		damage = pokeRound((damage *3)/2)
	
	#Damage Roll
	var damage_roll = context.damage_roll
	if damage_roll < 0:
		damage_roll = 0
	if damage_roll > 15:
		damage_roll = 15
	damage = floor( (damage * (100 - damage_roll)) /100)
	
	#Stab
	var is_stab = false
	if context.get_move().type == context.attacker.data.species.main_type:
		is_stab = true
	if context.get_move().type == context.attacker.data.species.secondary_type:
		is_stab = true
	var is_tera_boosted = context.attacker.state.terracrystalized and context.get_move().type == context.attacker.data.tera_type
	var has_adaptability = context.attacker.data.ability.name == "Adaptability"
	match([is_stab, is_tera_boosted, has_adaptability]):
		[true, false, false], [false, true, false]: #normaler Stab
			damage = apply_modifier(damage, 6144)
		[true, false, true] when not context.attacker.state.terracrystalized: #Adaptability Stab
			damage = apply_modifier(damage, 8192)
		[false, true, true], [true, true, false]: #Tera Adaptability Stab
			damage = apply_modifier(damage, 8192)
		[true, true, true]: #Megacombo
			damage = apply_modifier(damage, 9216)
	
	#Type Matchup
	var type_shift = check_type_matchup(context.get_move(), context.defender.get_typing())
	if type_shift == -10:
		damage = 0
	if type_shift > 0:
		damage = floor(damage * (2 ** type_shift))
	if type_shift < 0:
		damage = floor(damage / (2 ** -type_shift))
	
	#Burn
	match([context.attacker.state.condition, context.get_move().category]):
		["Burn", "Physical"]:
			damage = apply_modifier(damage, 2048)
	
	#Final Modifiers
	var final_modifier = calculate_final_modifier(context)
	damage = apply_modifier(damage, final_modifier)
	
	return damage

func calculate_percentage(context: AttackContext) -> float:
	var defender_hp: float = context.defender.data.get_hp_value()
	var attack_damage: float = calculate_complete_damage(context)
	
	#if attack_damage
	return (attack_damage / defender_hp) * 100

func get_heavy_slam_power(attacker_weight: float, defender_weight: float) -> float:
	var relative_weight = defender_weight / attacker_weight
	if relative_weight > 0.5:
		return 40
	elif relative_weight > 33.34:
		return 60
	elif relative_weight > 0.25:
		return 80
	elif relative_weight > 0.2:
		return 100
	else:
		return 120

func get_low_kick_power(weight: float) -> float:
	if weight < 10:
		return 20
	elif weight < 25:
		return 40
	elif weight < 50:
		return 60
	elif weight < 100:
		return 80
	elif weight < 200:
		return 100
	else:
		return 120

func check_type_matchup(move:Move, defense_types:Array[String]) -> int:
	var type_shifter:int = 0
	for defender_type in defense_types:
		match(move.type):
			"Normal":
				match(defender_type):
					"Ghost":
						return -10
					"Rock", "Steel":
						type_shifter -= 1
			"Fighting":
				match(defender_type):
					"Ghost":
						return -10
					"Flying", "Poison", "Bug", "Psychic", "Fairy":
						type_shifter -= 1
					"Normal", "Rock", "Steel", "Dark", "Ice":
						type_shifter += 1
			"Flying":
				match(defender_type):
					"Rock", "Steel", "Electric":
						type_shifter -= 1
					"Fighting", "Bug", "Grass":
						type_shifter += 1
			"Poison":
				match(defender_type):
					"Steel":
						return -10
					"Poison", "Ground", "Rock", "Ghost":
						type_shifter -= 1
					"Grass", "Fairy":
						type_shifter += 1
			"Ground":
				match(defender_type):
					"Flying":
						return -10
					"Bug", "Grass":
						type_shifter -= 1
					"Poison", "Rock", "Steel", "Fire", "Electric":
						type_shifter += 1
			"Rock":
				match(defender_type):
					"Fighting", "Ground", "Steel":
						type_shifter -= 1
					"Flying", "Bug", "Fire", "Ice":
						type_shifter += 1
			"Bug":
				match(defender_type):
					"Fighting", "Flying", "Poison", "Ghost", "Steel", "Fire", "Fairy":
						type_shifter -= 1
					"Grass", "Psychic", "Dark":
						type_shifter += 1
			"Ghost":
				match(defender_type):
					"Normal":
						return -10
					"Dark":
						type_shifter -= 1
					"Ghost", "Psychic":
						type_shifter += 1
			"Steel":
				match(defender_type):
					"Steel", "Fire", "Water", "Electric":
						type_shifter -= 1
					"Rock", "Ice", "Fairy":
						type_shifter += 1
			"Fire":
				match(defender_type):
					"Rock", "Fire", "Water", "Dragon":
						type_shifter -= 1
					"Bug", "Steel", "Grass", "Ice":
						type_shifter += 1
			"Water":
				match(defender_type):
					"Water", "Grass", "Dragon":
						type_shifter -= 1
					"Ground", "Rock", "Fire":
						type_shifter += 1
			"Grass":
				match(defender_type):
					"Flying", "Poison", "Bug", "Steel", "Fire", "Grass", "Dragon":
						type_shifter -= 1
					"Ground", "Rock", "Water":
						type_shifter += 1
			"Electric":
				match(defender_type):
					"Ground":
						return -10
					"Grass", "Electric", "Dragon":
						type_shifter -= 1
					"Flying", "Water":
						type_shifter += 1
			"Psychic":
				match(defender_type):
					"Dark":
						return -10
					"Steel", "Psychic":
						type_shifter -= 1
					"Fighting", "Poison":
						type_shifter += 1
			"Ice":
				match(defender_type):
					"Water":
						if move.name == "Freeze-Dry":
							type_shifter += 1
						else:
							type_shifter -= 1
					"Steel", "Fire", "Ice":
						type_shifter -= 1
					"Flying", "Ground", "Grass", "Dragon":
						type_shifter += 1
			"Dragon":
				match(defender_type):
					"Fairy":
						return 0
					"Steel":
						type_shifter -= 1
					"Dragon":
						type_shifter += 1
			"Dark":
				match(defender_type):
					"Fighting", "Dark", "Fairy":
						type_shifter -= 1
					"Ghost", "Psychic":
						type_shifter += 1
			"Fairy":
				match(defender_type):
					"Poison", "Steel", "Fire":
						type_shifter -= 1
					"Fighting", "Dragon", "Dark":
						type_shifter += 1
	return type_shifter
