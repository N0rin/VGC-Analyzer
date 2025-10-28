extends PanelContainer
class_name DefenseOVItem

@export var id = 0
@export var special = false
var value = 0

func set_value(pokemon_data: PokemonData):
	var hp = pokemon_data.get_hp_value()
	var defense = 1
	if special:
		defense = pokemon_data.get_spd_value()
		if pokemon_data.item and pokemon_data.item.name == "Assault Vest":
			defense = int(defense * 1.5)
		$MarginContainer/HBoxContainer/DamageType.text = "Special"
	else:
		defense = pokemon_data.get_def_value()
		$MarginContainer/HBoxContainer/DamageType.text = "Physical"
	if pokemon_data.item and pokemon_data.item.name == "Eviolite":
		defense = int(defense * 1.5)
	
	value = (hp * defense) / 100
	
	$MarginContainer/HBoxContainer/Species.text = pokemon_data.species.name
	$MarginContainer/HBoxContainer/Value.text = str(value)

func set_value_team(pokemon_team: TeamData):
	set_value(pokemon_team.team_members[id])
