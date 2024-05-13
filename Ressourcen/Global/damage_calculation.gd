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

func applyModifier(value : float, modifier : float) -> int:
	return pokeRound(value * (modifier / 4096) )

func combineModifier(old_value : float, new_modifier : float) -> int:
	return roundi((old_value * new_modifier) / 4096)

func calculateBaseDamage(base_power: float, attack: float, defense: float, level: float = 50):
	return floor(floor(floor( (2 * level) /5 + 2) * base_power * attack /defense) /50) +2

func calculateBasePower(move:Move, modifiers:Array[Modifier]):
	var modifier_value:float = 4096
	var move_power:float = move.base_damage
	for modifier in modifiers:
		match(modifier.name):
			#Terrains
			"Psychic Terrain":
				if move.name == "Expanding Force":
					move_power = 120
				if move.type == "Psychic":
					modifier_value = combineModifier(modifier_value, 5325)
			"Grassy Terrain":
				if move.type == "Grass":
					modifier_value = combineModifier(modifier_value, 5325)
			"Electric Terrain":
				if move.type == "Electric":
					modifier_value = combineModifier(modifier_value, 5325)
	
	return applyModifier(move_power, modifier_value)

func calculateAttackValue(pokemon:PokemonData, move:Move, modifiers:Array[Modifier]) -> int:
	var attack = 1
	var is_special = false
	if move.category == "Special":
		is_special = true
	
	if is_special:
		attack = pokemon.get_spa_value()
	else:
		attack = pokemon.get_atk_value()
	
	var stat_modifier = 0
	for modifier in modifiers:
		if modifier.category == CAT.StatStage:
			match([modifier.name, is_special]):
				["Atk-Stat", false], ["SpA-Stat", true]:
					stat_modifier = modifier.value
	
	if stat_modifier > 0:
		attack = floor(attack * (2 + stat_modifier)/2 ) 
	if stat_modifier < 0:
		attack = floor(attack * 2/(-stat_modifier+2) )
	
	var attack_modifier = 4096
	for modifier in modifiers:
		match([modifier.name, is_special]):
			["Tablets of Ruin", false], ["Vessel of Ruin", true]:
				attack_modifier = combineModifier(attack_modifier, 3072)
	for modifier in modifiers:
		match([modifier.name, is_special]):
			["Choice Band", false], ["Choice Specs", true]:
				attack_modifier = combineModifier(attack_modifier, 6144)
	
	return applyModifier(attack, attack_modifier)

func calculateDefenseValue(pokemon:PokemonData, move:Move, modifiers:Array[Modifier]) -> int:
	var defense = 1
	
	var is_special = false
	if move.category == "Special":
		is_special = true
	
	if is_special:
		defense = pokemon.get_spd_value()
	else:
		defense = pokemon.get_def_value()
	
	var stat_modifier = 0
	for modifier in modifiers:
		if modifier.category == CAT.StatStage:
			match([modifier.name, is_special]):
				["Def-Stat", false], ["SpD-Stat", true]:
					stat_modifier = modifier.value
	
	if stat_modifier > 0:
		defense = floor(defense * (2 + stat_modifier)/2 ) 
	if stat_modifier < 0:
		defense = floor(defense * 2/(-stat_modifier+2) )
	
	for modifier in modifiers:
		match([modifier.name, is_special,pokemon.species.main_type, pokemon.species.main_type]):
			["Sand", true, "Rock", _],["Sand", true, _, "Rock"]:
				defense = applyModifier(defense, 6144)
	
	var defense_modifier = 4096
	for modifier in modifiers:
		match([modifier.name, is_special]):
			["Eviolite", _], ["Assault Vest", true]:
				defense_modifier = combineModifier(defense_modifier, 6144)
	
	return applyModifier(defense, defense_modifier) 

func calculateFinalModifier(move:Move, modifiers:Array[Modifier], defender:PokemonData) -> int:
	var modifier_value = 4096
	
	for modifier in modifiers:
		match([modifier.name, move.category]):
			["Aurora Veil", _], ["Reflector", "Physical"],["Light Screen", "Special"]:
				modifier_value = combineModifier(modifier_value, 2732)
				break
	
	for modifier in modifiers:
		match(modifier.name):
			"Multiscale", "Shadow Shield":
				modifier_value = combineModifier(modifier_value, 2048)
	
	for modifier in modifiers:
		match(modifier.name):
			"Friend Guard":
				modifier_value = combineModifier(modifier_value, 3072)
	
	for modifier in modifiers:
		match(modifier.name):
			"Solid Rock", "Filter", "Prism Armor":
				if checkTypeMatchup(move, defender.get_types()) < 0:
					modifier_value = combineModifier(modifier_value, 3072)
	
	for modifier in modifiers:
		match(modifier.name):
			"Expert Belt":
				if checkTypeMatchup(move, defender.get_types()) > 0:
					modifier_value = combineModifier(modifier_value, 4915)
	
	for modifier in modifiers:
		match(modifier.name):
			"Life Orb":
				modifier_value = combineModifier(modifier_value, 5324)
	
	return modifier_value

func calculateCompleteDamage(attacker:PokemonData, defender:PokemonData, move_slot:int, damage_roll:int, modifiers:Array[Modifier]) -> int:
	var move = attacker.get_move(move_slot)
	var bp_modifiers:Array[Modifier]
	var attack_modifiers:Array[Modifier]
	var defense_modifiers:Array[Modifier]
	var general_modifiers:Array[Modifier]
	var final_modifiers:Array[Modifier]
	
	for modifier in modifiers:
		match(modifier.apply_on):
			STEP.BasePower:
				bp_modifiers.append(modifier)
			STEP.Attack:
				attack_modifiers.append(modifier)
			STEP.Defense:
				defense_modifiers.append(modifier)
			STEP.General:
				general_modifiers.append(modifier)
			STEP.Final:
				final_modifiers.append(modifier)
	
	var base_power = calculateBasePower(move, bp_modifiers)
	var attack = calculateAttackValue(attacker, move, attack_modifiers)
	var defense = calculateDefenseValue(defender, move, defense_modifiers)
	
	var damage:int = calculateBaseDamage(base_power, attack, defense)
	
	#Modifiers
	for modifier in general_modifiers:
		match(modifier.name):
			"Spread":
				damage = applyModifier(damage, 3072)
	
	for modifier in general_modifiers:
		match([modifier.name, move.type]):
			["Sun", "Fire"], ["Rain", "Water"]:
				damage = applyModifier(damage, 6144)
			["Sun", "Water"], ["Rain", "Fire"]:
				damage = applyModifier(damage, 2048)
	
	for modifier in general_modifiers:
		match(modifier.name):
			"Critical Hit":
				damage = pokeRound((damage *3)/2)
	
	if damage_roll < 0:
		damage_roll = 0
	if damage_roll > 15:
		damage_roll = 15
	damage = floor( (damage * (100 - damage_roll)) /100)
	
	if move.type == attacker.species.main_type or move.type == attacker.species.secondary_type:
		damage = applyModifier(damage, 6144)
	
	var type_shifter = checkTypeMatchup(move, [defender.species.main_type, defender.species.secondary_type])
	damage = damage<<type_shifter
	
	for modifier in general_modifiers:
		match([modifier.name, move.category]):
			["Burn", "Physical"]:
				damage = applyModifier(damage, 2048)
	
	var final_modifier = calculateFinalModifier(move, final_modifiers, defender)
	damage = applyModifier(damage, final_modifier)
	
	return damage

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

func checkTypeMatchup(move:Move, defense_types:Array[String]) -> int:
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

func isPokemonGrounded(pokemon: Pokemon) -> bool:
	match(pokemon.get_typing()):
		["Flying", _], [_, "Flying"]:
			return false
	if pokemon.data.ability.name == "Levitate":
		return false
	if pokemon.data.item.name == "Air Balloon":
		return false
	
	return true
