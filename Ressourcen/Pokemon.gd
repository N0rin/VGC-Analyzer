extends Resource
class_name Pokemon

var data:PokemonData
var state:PokemonState

func get_typing() -> Array[String]:
	if state.terracrystalized:
		return [data.tera_type, ""]
	
	return data.get_base_types()
