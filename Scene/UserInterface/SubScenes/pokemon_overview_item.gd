extends PanelContainer
class_name PokemonOverviewItem

var pokemon_data: Species

@onready var total_value = 0

@onready var name_label = $MarginContainer/HBoxContainer/Name
@onready var offense_label = $MarginContainer/HBoxContainer/RawOffense
@onready var defense_label = $MarginContainer/HBoxContainer/RawDefense
@onready var special_defense_label = $MarginContainer/HBoxContainer/RawSpecialDefense
@onready var speed_label = $MarginContainer/HBoxContainer/RawSpeed
@onready var total_label = $MarginContainer/HBoxContainer/RawTotal

func load_pokemon():
	set_sprite(pokemon_data.texture_x, pokemon_data.texture_y, pokemon_data.texture_id)
	name_label.text = pokemon_data.name
	offense_label.text = "%s" % get_offense()
	defense_label.text = "%s" % get_physical_defense()
	special_defense_label.text = "%s" % get_special_defense()
	speed_label.text = "%s" % get_speed()
	total_label.text = "%s" % get_total()

func get_offense(factor = 1) -> float:
	if pokemon_data.atk < pokemon_data.spa:
		return pokemon_data.spa * factor
	
	return pokemon_data.atk * factor

func get_physical_defense(factor = 1) -> float:
	return round(((pokemon_data.hp +75)*(pokemon_data.def + 20)) /210) * factor

func get_special_defense(factor = 1) -> float:
	return round(((pokemon_data.hp +75)*(pokemon_data.spd + 20)) /210) * factor

func get_speed(factor = 1) -> float:
	return pokemon_data.spe * factor

func get_total(factors = [1,1,1,1]) -> float:
	var multiplicator = 0
	for value in factors:
		if value > 0:
			multiplicator += 1 
	
	multiplicator /= (factors[0] + factors[1] + factors[2] + factors[3])
	total_value = round((get_offense(factors[0]) + get_physical_defense(factors[1]) + get_special_defense(factors[2]) + get_speed(factors[3])) * multiplicator)
	return total_value

func set_sprite(x: int, y: int, source_id: int = 4):
	$MarginContainer/HBoxContainer/Icon/TileMap.set_cell(0, Vector2i.ZERO, source_id, Vector2i(x, y), 0)

func set_total(value):
	total_label.text = "%s" % value
