extends PanelContainer
class_name HPOVItem

@export var id = 0
var value = 0

func set_value(pokemon_data: PokemonData):
	value = pokemon_data.get_hp_value()
	
	$MarginContainer/HBoxContainer/Species.text = pokemon_data.species.name
	$MarginContainer/HBoxContainer/Value.text = str(value)
	$"MarginContainer/HBoxContainer/1_8".text = str(floor(value/8))
	$"MarginContainer/HBoxContainer/1_16".text = str(floor(value/16))

func set_value_team(pokemon_team: TeamData):
	set_value(pokemon_team.team_members[id])
