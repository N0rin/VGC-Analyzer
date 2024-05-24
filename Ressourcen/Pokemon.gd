extends Resource
class_name Pokemon

var data:PokemonData
var state:PokemonState

func get_typing() -> Array[String]:
	if state.terracrystalized and data.tera_type != "Stellar":
		return [data.tera_type, "None"]
	
	return data.get_base_types()

func get_current_hp() -> int:
	return data.get_hp_value() - state.damage_received

func is_grounded() -> bool:
	match(get_typing()):
		["Flying", _], [_, "Flying"]:
			return false
	if data.ability.name == "Levitate":
		return false
	if data.item.name == "Air Balloon":
		return false
	
	return true

func get_field_atk() -> int:
	return get_modified_stat(data.get_atk_value(), state.attack_stack)

func get_field_def() -> int:
	return get_modified_stat(data.get_def_value(), state.defense_stack)

func get_field_spa() -> int:
	return get_modified_stat(data.get_spa_value(), state.special_attack_stack)

func get_field_spd() -> int:
	return get_modified_stat(data.get_spd_value(), state.special_defense_stack)

func get_field_spe() -> int:
	return get_modified_stat(data.get_spe_value(), state.speed_stack)

func get_modified_stat(value: float, stack: float) -> int:
	if stack > 0:
		return floor(value * (2 + stack)/2 ) 
	if stack < 0:
		return floor(value * 2/(-stack+2) )
	return value
