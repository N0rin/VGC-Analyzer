extends Node
class_name SaveLoader

const SAVE_GAME_BASE_PATH := "user://games/"
const SAVE_VERSION := 1

func verify_save_directory(path:String):
	DirAccess.make_dir_absolute(path)
	
func save_data(path:String, game_data:GameData):
	var file = FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		print(FileAccess.get_open_error())
		return
	
	var data = {
		"version" = SAVE_VERSION,
		"upper_team" = [poke_dic(game_data.upper_team[0]), poke_dic(game_data.upper_team[1]), poke_dic(game_data.upper_team[2]),
			poke_dic(game_data.upper_team[3]), poke_dic(game_data.upper_team[4]), poke_dic(game_data.upper_team[5])],
		"lower_team" = [poke_dic(game_data.lower_team[0]), poke_dic(game_data.lower_team[1]), poke_dic(game_data.lower_team[2]), 
			poke_dic(game_data.lower_team[3]), poke_dic(game_data.lower_team[4]), poke_dic(game_data.lower_team[5])],
		"game_state_data" = game_data.game_state_data
		}
	
	var json_string = JSON.stringify(data, "\t")
	file.store_string(json_string)
	file.close()

func load_data(path: String):
	if FileAccess.file_exists(path):
		var file = FileAccess.open(path, FileAccess.READ)
		if file == null:
			print(FileAccess.get_open_error())
			return
		
		var content = file.get_as_text()
		file.close
		
		var data = JSON.parse_string(content)
		if data == null:
			printerr("Cannont parse %s as a json_string: (%s)" % [path, content])
		
		return read_data(data)


func poke_dic(pokemon_data: PokemonData):
	if pokemon_data == null:
		return null
	
	return {
		"species" = species_dic(pokemon_data.species),
		#"ability" = pokemon_data.ability,
		#"item" = pokemon_data.item,
		"tera_type" = pokemon_data.tera_type,
		"increased_stat" = pokemon_data.increased_stat,
		"reduced_stat" = pokemon_data.reduced_stat,
		"hp_evs" = pokemon_data.hp_evs,
		"atk_evs" = pokemon_data.atk_evs,
		"def_evs" = pokemon_data.def_evs,
		"spa_evs" = pokemon_data.spa_evs,
		"spd_evs" = pokemon_data.spd_evs,
		"spe_evs" = pokemon_data.spe_evs,
		"hp_ivs" = pokemon_data.hp_ivs,
		"atk_ivs" = pokemon_data.atk_ivs,
		"def_ivs" = pokemon_data.def_ivs,
		"spa_ivs" = pokemon_data.spa_ivs,
		"spd_ivs" = pokemon_data.spd_ivs,
		"spe_ivs" = pokemon_data.spe_ivs,
		#"move1" = pokemon_data.move1,
		#"move2" = pokemon_data.move2,
		#"move3" = pokemon_data.move3,
		#"move4" = pokemon_data.move4
	}

func species_dic(species: Species):
	return {
		"sprite" = species.sprite,
		"name" = species.name,
		"main_type" = species.main_type,
		"secondary_type" = species.secondary_type,
		"hp" = species.hp,
		"atk" = species.atk,
		"def" = species.def,
		"spa" = species.spa,
		"spd" = species.spd,
		"spe" = species.spe
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
	game_data.upper_team = read_pokedata(data["lower_team"])
	game_data.game_state_data = read_gamestate_data(data["gamestate"])

func read_pokedata(pokedata: Array):
	var pokedata_list = []
	
	for data in pokedata:
		var real_pokedata = PokemonData.new()
		"species" = species_dic(pokemon_data.species),
		#"ability" = pokemon_data.ability,
		#"item" = pokemon_data.item,
		"tera_type" = pokemon_data.tera_type,
		"increased_stat" = pokemon_data.increased_stat,
		"reduced_stat" = pokemon_data.reduced_stat,
		"hp_evs" = pokemon_data.hp_evs,
		"atk_evs" = pokemon_data.atk_evs,
		"def_evs" = pokemon_data.def_evs,
		"spa_evs" = pokemon_data.spa_evs,
		"spd_evs" = pokemon_data.spd_evs,
		"spe_evs" = pokemon_data.spe_evs,
		"hp_ivs" = pokemon_data.hp_ivs,
		"atk_ivs" = pokemon_data.atk_ivs,
		"def_ivs" = pokemon_data.def_ivs,
		"spa_ivs" = pokemon_data.spa_ivs,
		"spd_ivs" = pokemon_data.spd_ivs,
		"spe_ivs" = pokemon_data.spe_ivs,
		#"move1" = pokemon_data.move1,
		#"move2" = pokemon_data.move2,
		#"move3" = pokemon_data.move3,
		#"move4" = pokemon_data.move4

func read_gamestate_data(gamestate_data: Dictionary):
	pass
