extends Node

const SPREAD = 3072
const WEATHER_BOOST = 6144
const WEATHER_DEBUFF = 2048

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

func calculateAttackValue(pokemon:PokemonData, move:Move) -> int:
	return 1

func calculateDefenseValue(pokemon:PokemonData, move:Move) -> int:
	return 1

func calculateCompleteDamage(attacker:PokemonData, defender:PokemonData, move_slot:int, damage_roll:int ,modifiers:Array) -> int:
	return 1
