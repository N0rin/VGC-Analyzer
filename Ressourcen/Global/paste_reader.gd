extends Node
class_name PasteReader

const DATA_PATH = "res://Ressourcen/"

@onready var pokemon_list: Array[Species]
@onready var item_list: Array[Item]
@onready var ability_list: Array[Ability]
@onready var move_list: Array[Move]

func _init() -> void:
	load_data()

func load_data() -> void:
	load_into_list(pokemon_list, "Species")
	load_into_list(move_list, "Moves")
	load_into_list(item_list, "Items")
	load_into_list(ability_list, "Abilities")

func load_into_list(list: Array, dirname: String):
	var dir = DirAccess.open(DATA_PATH)
	var file_list = dir.get_files_at(DATA_PATH + dirname)
	
	for filename in file_list:
		list.append(load(DATA_PATH + dirname + "/" + filename))

func check_list_for_contained(list: Array, text: String):
	for thing in list:
		if text.contains(thing.name):
			return thing
	return null

func convert_paste_data(paste: String, format = 0) -> TeamData:
	var team_data = TeamData.new()
	team_data.format = format
	var segments = paste.split("\n\n",false) 
	
	for i in segments.size():
		team_data.team_members[i] = create_pokemon(segments[i])
	
	return team_data


func create_pokemon(text: String) -> PokemonData:
	var pokemon = PokemonData.new()
	var lines = text.split("\n")
	
	var pokemon_name = lines[0].get_slice("@", 0)
	var species = check_list_for_contained(pokemon_list, pokemon_name)
	if species:
		pokemon.species = species
	
	var item_name = ""
	if lines[0].contains("@"):
		item_name = lines[0].get_slice("@", 1)
	else:
		item_name = "No Item"
	var item = check_list_for_contained(item_list, item_name)
	if item:
		pokemon.item = item
	
	var ability_name = ""
	var move_names: Array[String]
	for line in lines:
		if line.contains("Ability: "):
			ability_name = line.get_slice("Ability: ", 1)
		
		if line.contains("EVs: "):
			var distribution_text = line.get_slice("EVs: ", 1).split(" / ")
			for stat_text in distribution_text:
				if stat_text.contains(" HP"):
					pokemon.hp_stat = int(stat_text.get_slice(" HP", 0))
				if stat_text.contains(" Atk"):
					pokemon.atk_stat = int(stat_text.get_slice(" Atk", 0))
				if stat_text.contains(" Def"):
					pokemon.def_stat = int(stat_text.get_slice(" Def", 0))
				if stat_text.contains(" SpA"):
					pokemon.spa_stat = int(stat_text.get_slice(" SpA", 0))
				if stat_text.contains(" SpD"):
					pokemon.spd_stat = int(stat_text.get_slice(" SpD", 0))
				if stat_text.contains(" Spe"):
					pokemon.spe_stat = int(stat_text.get_slice(" Spe", 0))
			
		if line.contains(" Nature"):
			var nature_name = line.get_slice(" Nature", 0)
			match nature_name:
				"Bold", "Modest", "Calm", "Timid":
					pokemon.reduced_stat = "Atk"
				"Lonely", "Mild", "Gentle", "Hasty":
					pokemon.reduced_stat = "Def"
				"Adamant", "Impish", "Careful", "Jolly":
					pokemon.reduced_stat = "SpA"
				"Naughty", "Lax", "Rash", "Naive":
					pokemon.reduced_stat = "SpD"
				"Brave", "Relaxed", "Quiet", "Sassy":
					pokemon.reduced_stat = "Spe"
			
			match nature_name:
				"Lonely", "Adamant", "Naughty", "Brave":
					pokemon.increased_stat = "Atk"
				"Bold", "Impish", "Lax", "Relaxed":
					pokemon.increased_stat = "Def"
				"Modest", "Mild", "Rash", "Quiet":
					pokemon.increased_stat = "SpA"
				"Calm", "Gentle", "Careful", "Sassy":
					pokemon.increased_stat = "SpD"
				"Timid", "Hasty", "Jolly", "Naive":
					pokemon.increased_stat = "Spe"
		
		if line.contains("- "):
			move_names.append(line.get_slice("- ", 1))
	
	var ability = check_list_for_contained(ability_list, ability_name)
	if ability:
		pokemon.ability = ability
	
	var moves = []
	for i in move_names.size():
		var move = check_list_for_contained(move_list, move_names[i])
		if move:
			moves.append(move)
	
	if moves.size() > 0:
		pokemon.move1 = moves[0]
	if moves.size() > 1:
		pokemon.move2 = moves[1]
	if moves.size() > 2:
		pokemon.move3 = moves[2]
	if moves.size() > 3:
		pokemon.move4 = moves[3]
	
	return pokemon
