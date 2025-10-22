extends PanelContainer
class_name DefenseOVItem

@export var id = 0
@export var special = false

func set_value(pokemon_data: PokemonData):
	var hp = pokemon_data.get_hp_value()
	var defense = 1
	if special:
		defense = pokemon_data.get_spd_value()
		$MarginContainer/HBoxContainer/DamageType.text = "Special"
	else:
		defense = pokemon_data.get_def_value()
		$MarginContainer/HBoxContainer/DamageType.text = "Physical"
	
	var value = (hp * defense) / 100
	
	$MarginContainer/HBoxContainer/Species.text = pokemon_data.species.name
	$MarginContainer/HBoxContainer/Value.text = str(value)
