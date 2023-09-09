extends Resource
class_name GameData

@export var version:= 1

@export var upper_team:Array[PokemonData] = [null, null, null, null, null, null]
@export var lower_team:Array[PokemonData] = [null, null, null, null, null, null]
@export var game_state_data : GameStateData
