extends Resource
class_name PokemonData

@export var name : String = "new Set"
@export_enum("All", "Reg M-A", "Reg M-B") var format = "All"

@export var species : Species
@export var ability : Ability
@export var item : Item
@export_enum( "Normal", "Grass", "Fire", "Water", "Electric", "Fighting", "Flying", 
"Poison", "Ground", "Rock", "Bug", "Ice", "Psychic", "Ghost", "Dragon", "Dark",
"Steel", "Fairy", "Stellar" ) var tera_type = "Normal"
@export_category("Stat Points")
@export_enum("None","Atk", "Def", "SpA", "SpD", "Spe") var increased_stat = "None"
@export_enum("None", "Atk", "Def", "SpA", "SpD", "Spe") var reduced_stat = "None"
@export var hp_stat = 0
@export var atk_stat = 0
@export var def_stat = 0
@export var spa_stat = 0
@export var spd_stat = 0
@export var spe_stat = 0
@export_category("Individual Values")
@export var hp_ivs = 31
@export var atk_ivs = 31
@export var def_ivs = 31
@export var spa_ivs = 31
@export var spd_ivs = 31
@export var spe_ivs = 31
@export_category("Moves")
@export var move1 : Move
@export var move2 : Move
@export var move3 : Move
@export var move4 : Move


func get_move(value:int) -> Move:
	match(value):
		2:
			return move2
		3:
			return move3
		4:
			return move4
		_:
			return move1

func get_base_types() -> Array[String]:
	return [species.main_type, species.secondary_type]

func get_hp_value() -> int:
	return damage_calculation.pokeRound(((( 2 * species.hp + hp_ivs) * 50) /100) + 60 + hp_stat)

func get_atk_value() -> int:
	var atk = damage_calculation.pokeRound(((( 2 * species.atk + atk_ivs) * 50) /100) + 5 + atk_stat)
	if increased_stat == "Atk":
		return floor(atk * 1.1)
	return atk

func get_def_value() -> int:
	var def = damage_calculation.pokeRound(((( 2 * species.def + def_ivs) * 50) /100) + 5 + def_stat)
	if increased_stat == "Def":
		return floor(def * 1.1)
	return def

func get_spa_value() -> int:
	var spa = damage_calculation.pokeRound(((( 2 * species.spa + spa_ivs) * 50) /100) + 5 + spa_stat)
	if increased_stat == "SpA":
		return floor(spa * 1.1)
	return spa

func get_spd_value() -> int:
	var spd = damage_calculation.pokeRound(((( 2 * species.spd + spd_ivs) * 50) /100) + 5 + spd_stat)
	if increased_stat == "SpD":
		return floor(spd * 1.1)
	return spd

func get_spe_value() -> int:
	var spe = damage_calculation.pokeRound(((( 2 * species.spe + spe_ivs) * 50) /100) + 5 + spe_stat)
	if increased_stat == "Spe":
		return floor(spe * 1.1)
	return spe
