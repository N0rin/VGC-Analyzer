extends Node
class_name SaveLoader

const SAVE_GAME_BASE_PATH := "user://games/"
const SAVE_VERSION := 1

func verify_save_directory(path:String):
	DirAccess.make_dir_absolute(get_file_path(path))

func get_file_path(filename: String) -> String:
	return SAVE_GAME_BASE_PATH + filename + ".json"

func save_data(path:String, game_data:GameData):
	var file = FileAccess.open(get_file_path(path), FileAccess.WRITE)
	if file == null:
		print(FileAccess.get_open_error())
		return
	
	var data = {
		"version" = SAVE_VERSION,
		"upper_team" = [poke_dic(game_data.upper_team[0]), poke_dic(game_data.upper_team[1]), poke_dic(game_data.upper_team[2]),
			poke_dic(game_data.upper_team[3]), poke_dic(game_data.upper_team[4]), poke_dic(game_data.upper_team[5])],
		"lower_team" = [poke_dic(game_data.lower_team[0]), poke_dic(game_data.lower_team[1]), poke_dic(game_data.lower_team[2]), 
			poke_dic(game_data.lower_team[3]), poke_dic(game_data.lower_team[4]), poke_dic(game_data.lower_team[5])],
		"gamestate_data" = state_dic(game_data.game_state_data)
		}
	
	var json_string = JSON.stringify(data)
	file.store_string(json_string)
	file.close()

func load_data(path: String):
	if FileAccess.file_exists(get_file_path(path)):
		var file = FileAccess.open(get_file_path(path), FileAccess.READ)
		if file == null:
			print(FileAccess.get_open_error())
			return
		
		var content = file.get_as_text()
		file.close
		
		var data = JSON.parse_string(content)
		if data == null:
			printerr("Cannont parse %s as a json_string: (%s)" % [get_file_path(path), content])
		
		return read_data(data)


func poke_dic(pokemon_data: PokemonData):
	if pokemon_data == null:
		return null
	
	return {
		"species_path" = pokemon_data.species.resource_path,
		"ability_path" = pokemon_data.ability.resource_path,
		"item_path" = pokemon_data.item.resource_path,
		"tera_type" = pokemon_data.tera_type,
		"increased_stat" = pokemon_data.increased_stat,
		"reduced_stat" = pokemon_data.reduced_stat,
		"hp_stat" = pokemon_data.hp_stat,
		"atk_stat" = pokemon_data.atk_stat,
		"def_stat" = pokemon_data.def_stat,
		"spa_stat" = pokemon_data.spa_stat,
		"spd_stat" = pokemon_data.spd_stat,
		"spe_stat" = pokemon_data.spe_stat,
		"hp_ivs" = pokemon_data.hp_ivs,
		"atk_ivs" = pokemon_data.atk_ivs,
		"def_ivs" = pokemon_data.def_ivs,
		"spa_ivs" = pokemon_data.spa_ivs,
		"spd_ivs" = pokemon_data.spd_ivs,
		"spe_ivs" = pokemon_data.spe_ivs,
		"move1_path" = pokemon_data.move1.resource_path,
		"move2_path" = pokemon_data.move2.resource_path,
		"move3_path" = pokemon_data.move3.resource_path,
		"move4_path" = pokemon_data.move4.resource_path
	}

func state_dic(gamestate: GameStateData):
	
	if gamestate.children.size() < 1:
		return {
		"state_name" = gamestate.state_name,
		"state_turn" = gamestate.state_turn,
		"commentary" = gamestate.commentary,
		"field_effects" = field_dic(gamestate.field_effects),
		"upper_team_lineup" = gamestate.upper_team_lineup,
		"upper_team_states" = poke_states_dic(gamestate.upper_team_states),
		"lower_team_lineup" = gamestate.lower_team_lineup,
		"lower_team_states" = poke_states_dic(gamestate.lower_team_states)
	}
	
	else:
		var children = []
		for child in gamestate.children:
			children.append(state_dic(child))
		return {
		"children" = children,
			
		"state_name" = gamestate.state_name,
		"state_turn" = gamestate.state_turn,
		"commentary" = gamestate.commentary,
		"field_effects" = field_dic(gamestate.field_effects),
		"upper_team_lineup" = gamestate.upper_team_lineup,
		"upper_team_states" = poke_states_dic(gamestate.upper_team_states),
		"lower_team_lineup" = gamestate.lower_team_lineup,
		"lower_team_states" = poke_states_dic(gamestate.lower_team_states)
	}

func field_dic(field_effects:Array[FieldEffectData]):
	var field_list = []
	for effect in field_effects:
		var field_data = {
			"name" = effect.name,
			"duration" = effect.duration,
			"position" = effect.position
		}
		field_list.append(field_data)
	return field_list

func poke_states_dic(pokestates: Array[PokemonState]):
	var pokestate_list = []
	for pokestate in pokestates:
		var pokestate_data = {
			"health" = pokestate.health,
			"condition" = pokestate.condition,
			"terracrystalized" = pokestate.terracrystalized,
			"combat_data" = pokestate.combat_data
		}
		pokestate_list.append(pokestate_data)
	return pokestate_list

func read_data(data: Dictionary):
	var game_data = GameData.new()
	game_data.version = data["version"]
	game_data.upper_team = read_pokedata(data["upper_team"])
	game_data.lower_team = read_pokedata(data["lower_team"])
	game_data.game_state_data = read_gamestate_data(data["gamestate_data"])
	return game_data

func read_pokedata(pokedata: Array):
	var pokedata_list:Array[PokemonData] = []
	
	for data in pokedata:
		if data == null:
			pokedata_list.append(null)
			continue
		
		var real_pokedata = PokemonData.new()
		real_pokedata.species = load(data["species_path"])
		real_pokedata.ability = load(data["ability_path"])
		real_pokedata.item = load(data["item_path"])
		real_pokedata.tera_type = data["tera_type"]
		real_pokedata.increased_stat = data["increased_stat"]
		real_pokedata.reduced_stat = data["reduced_stat"]
		real_pokedata.hp_stat = data["hp_stat"]
		real_pokedata.atk_stat = data["atk_stat"]
		real_pokedata.def_stat = data["def_stat"]
		real_pokedata.spa_stat = data["spa_stat"]
		real_pokedata.spd_stat = data["spd_stat"]
		real_pokedata.spe_stat = data["spe_stat"]
		real_pokedata.hp_ivs = data["hp_ivs"]
		real_pokedata.atk_ivs = data["atk_ivs"]
		real_pokedata.def_ivs = data["def_ivs"]
		real_pokedata.spa_ivs = data["spa_ivs"]
		real_pokedata.spd_ivs = data["spd_ivs"]
		real_pokedata.spe_ivs = data["spe_ivs"]
		real_pokedata.move1 = load(data["move1_path"])
		real_pokedata.move2 = load(data["move2_path"])
		real_pokedata.move3 = load(data["move3_path"])
		real_pokedata.move4 = load(data["move4_path"])
		pokedata_list.append(real_pokedata)
	
	return pokedata_list

func read_gamestate_data(gamestate_data: Dictionary, parent = null):
	var gamestate = GameStateData.new()
	gamestate.state_name = gamestate_data["state_name"]
	gamestate.state_turn = gamestate_data["state_turn"]
	gamestate.commentary = gamestate_data["commentary"]
	gamestate.field_effects = read_field_effects(gamestate_data["field_effects"])
	gamestate.upper_team_lineup = read_lineup(gamestate_data["upper_team_lineup"])
	gamestate.upper_team_states = read_team_states(gamestate_data["upper_team_states"])
	gamestate.lower_team_lineup = read_lineup(gamestate_data["lower_team_lineup"])
	gamestate.lower_team_states = read_team_states(gamestate_data["lower_team_states"])
	
	gamestate.parent = parent
	
	if gamestate_data.get("children") != null:
		for gamestate_data_child in gamestate_data["children"]:
			var gamestate_child = read_gamestate_data(gamestate_data_child, gamestate)
			gamestate.children.append(gamestate_child)
	
	return gamestate

func read_field_effects(effect_list: Array):
	var field_effects: Array[FieldEffectData] = []
	for effect_data in effect_list:
		var field_effect = FieldEffectData.new()
		field_effect.name = effect_data["name"]
		field_effect.duration = effect_data["duration"]
		field_effect.position = effect_data["position"]
		field_effects.append(field_effect)
	
	return field_effects

func read_lineup(lineup_data: Array) -> Array[int]:
	var lineup: Array[int] = []
	for value in lineup_data:
		lineup.append(int(value))
	
	return lineup

func read_team_states(poke_state_data: Array):
	var pokestates: Array[PokemonState] = []
	for state_data in poke_state_data:
		var pokestate = PokemonState.new()
		pokestate.health = state_data["health"]
		pokestate.condition = state_data["condition"]
		pokestate.terracrystalized = state_data["terracrystalized"]
		pokestate.combat_data = state_data["combat_data"]
		pokestates.append(pokestate)
	
	return pokestates
