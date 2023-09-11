extends Resource
class_name GameStateData

var parent:GameStateData = null
var children:Array[GameStateData] = [] 

var state_name = ""
var state_turn = 0
var commentary = ""

var field_effects:Array[FieldEffectData] = []
var upper_team_lineup:Array[int] = [0,1,2,3,4,5]
var upper_team_states:Array[PokemonState] = [PokemonState.new(),PokemonState.new(),PokemonState.new(),PokemonState.new(),PokemonState.new(),PokemonState.new()]
var lower_team_lineup:Array[int] = [0,1,2,3,4,5]
var lower_team_states:Array[PokemonState] = [PokemonState.new(),PokemonState.new(),PokemonState.new(),PokemonState.new(),PokemonState.new(),PokemonState.new()]

func get_child_at_path(tree_path: Array[int]) -> GameStateData:
	if tree_path.size() == 0:
		return self
	if tree_path.size() == 1:
		if tree_path[0] <= children.size():
			return children[tree_path[0]]
		else:
			return null
	else:
		var child = children[tree_path[0]]
		tree_path.pop_front()
		return child.get_child_at_path(tree_path)

func add_child_at_path(tree_path: Array[int], gamestate:GameStateData) -> void:
	var parent : GameStateData = get_child_at_path(tree_path)
	parent.children.append(gamestate)

func edit_child_at_path(tree_path: Array[int], gamestate:GameStateData) -> void:
	var child_position:int = tree_path.pop_back()
	var parent : GameStateData = get_child_at_path(tree_path)
	parent.children[child_position] = gamestate

func switch_position(position_a:int, position_b:int, is_upper:bool) -> void:
	var lineup: Array[int]
	var pokemon_states: Array[PokemonState]
	
	if is_upper:
		lineup = upper_team_lineup
		pokemon_states = upper_team_states
	else:
		lineup = lower_team_lineup
		pokemon_states = lower_team_states
	
	var switched_lineup_value = lineup[position_a]
	var switched_pokemon_state_value = pokemon_states[position_a]
	
	lineup[position_a] = lineup[position_b]
	pokemon_states[position_a] = pokemon_states[position_b]
	
	lineup[position_b] = switched_lineup_value
	pokemon_states[position_b] = switched_pokemon_state_value

func iterate_field() -> void:
	var size = field_effects.size()
	for i in range(size):
		var index = size-1-i
		field_effects[index].duration -= 1
	
		if field_effects[index].duration == 0:
			field_effects.remove_at(index)
	
	state_turn += 1
