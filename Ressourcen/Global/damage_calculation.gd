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
		attack = pokemon.get_spd_value()
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
			["Choice Band", false], ["Choice Specs", true]:
				attack_modifier = combineModifier(attack_modifier, 6144)
	
	return applyModifier(attack, attack_modifier)

func calculateDefenseValue(pokemon:PokemonData, move:Move, modifiers:Array[Modifier]) -> int:
	return 1

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
	
	var damage = calculateBaseDamage(base_power, attack, defense)
	
	#Modifiers
	
	return damage
