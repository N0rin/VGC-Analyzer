extends PanelContainer
class_name SpeedOVItem

@export var id = 0
var value = 0

func set_value(pokemon_data: PokemonData):
	value = pokemon_data.get_spe_value()
	if pokemon_data.item and pokemon_data.item.name == "Choice Scarf":
		value = floor(value * 1.5)
	
	$MarginContainer/HBoxContainer/Species.text = pokemon_data.species.name
	$MarginContainer/HBoxContainer/Value.text = str(value)
	$MarginContainer/HBoxContainer/SpeedyBase.text = str(ceil(value / 1.1 ) - 52)
	$MarginContainer/HBoxContainer/StrongBase.text = str(value - 52)

func set_value_team(pokemon_team: TeamData):
	set_value(pokemon_team.team_members[id])
