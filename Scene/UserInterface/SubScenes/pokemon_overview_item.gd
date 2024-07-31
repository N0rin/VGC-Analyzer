extends PanelContainer
class_name PokemonOverviewItem

var pokemon_data: Species

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

func get_offense() -> float:
	if pokemon_data.atk < pokemon_data.spa:
		return pokemon_data.spa
	
	return pokemon_data.atk

func get_physical_defense() -> float:
	return round(((pokemon_data.hp +75)*(pokemon_data.def + 20)) /210)

func get_special_defense() -> float:
	return round(((pokemon_data.hp +75)*(pokemon_data.spd + 20)) /210)

func get_speed() -> float:
	return pokemon_data.spe

func get_total() -> float:
	return get_offense() + get_physical_defense() + get_special_defense() + get_speed()

func set_sprite(x: int, y: int, source_id: int = 4):
	$MarginContainer/HBoxContainer/Icon/TileMap.set_cell(0, Vector2i.ZERO, source_id, Vector2i(x, y), 0)
