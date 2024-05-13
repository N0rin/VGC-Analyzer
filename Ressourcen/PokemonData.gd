extends Resource
class_name PokemonData

@export var set_name : String
@export var species : Species
@export var ability : Ability
@export var item : Item
@export_enum( "Normal", "Grass", "Fire", "Water", "Electric", "Fighting", "Flying", 
"Poison", "Ground", "Rock", "Bug", "Ice", "Psychic", "Ghost", "Dragon", "Dark",
"Steel", "Fairy", "Stellar" ) var tera_type = "Normal"
@export_category("Effort Values")
@export_enum("None","Atk", "Def", "SpA", "SpD", "Spe") var increased_stat = "None"
@export_enum("None", "Atk", "Def", "SpA", "SpD", "Spe") var reduced_stat = "None"
@export var hp_evs = 0
@export var atk_evs = 0
@export var def_evs = 0
@export var spa_evs = 0
@export var spd_evs = 0
@export var spe_evs = 0
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

func load_species(species_name: String):
	species = load("res://Ressourcen/Species/" + species_name + ".tres")

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
	return damage_calculation.pokeRound(((( 2 * species.hp + hp_ivs + (hp_evs/4)) * 50) /100) + 60)

func get_atk_value() -> int:
	var atk = damage_calculation.pokeRound(((( 2 * species.atk + atk_ivs + (atk_evs/4)) * 50) /100) + 5)
	if increased_stat == "Atk":
		return floor(atk * 1.1)
	return atk

func get_def_value() -> int:
	var def = damage_calculation.pokeRound(((( 2 * species.def + def_ivs + (def_evs/4)) * 50) /100) + 5)
	if increased_stat == "Def":
		return floor(def * 1.1)
	return def

func get_spa_value() -> int:
	var spa = damage_calculation.pokeRound(((( 2 * species.spa + spa_ivs + (spa_evs/4)) * 50) /100) + 5)
	if increased_stat == "SpA":
		return floor(spa * 1.1)
	return spa

func get_spd_value() -> int:
	var spd = damage_calculation.pokeRound(((( 2 * species.spd + spd_ivs + (spd_evs/4)) * 50) /100) + 5)
	if increased_stat == "SpD":
		return floor(spd * 1.1)
	return spd

func get_spe_value() -> int:
	var spe = damage_calculation.pokeRound(((( 2 * species.spe + spe_ivs + (spe_evs/4)) * 50) /100) + 5)
	if increased_stat == "Spe":
		return floor(spe * 1.1)
	return spe
