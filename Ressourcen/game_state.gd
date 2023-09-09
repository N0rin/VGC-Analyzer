extends Control
class_name GameStateInterface

@onready var field_effect_scene = load("res://Scene/field_info.tscn")
@onready var data: GameStateData
@onready var upper_pokemon_data:Array[PokemonData] = [null,null,null,null,null,null]
@onready var lower_pokemon_data:Array[PokemonData] = [null,null,null,null,null,null]

func set_data(state_data:GameStateData) -> void:
	data = state_data
	refresh_from_data()

func set_teams(upper_data:Array[PokemonData], lower_data:Array[PokemonData]) -> void:
	upper_pokemon_data = upper_data
	lower_pokemon_data = lower_data

func get_pokemon(slot:int, is_upper_team:bool) -> Pokemon:
	var pokemon:= Pokemon.new()
	if is_upper_team:
		if upper_pokemon_data[data.upper_team_lineup[slot]] == null:
			return null
		pokemon.data = upper_pokemon_data[data.upper_team_lineup[slot]]
		pokemon.state = data.upper_team_states[slot]
	else:
		if lower_pokemon_data[data.lower_team_lineup[slot]] == null:
			return null
		pokemon.data = lower_pokemon_data[data.lower_team_lineup[slot]]
		pokemon.state = data.lower_team_states[slot]
	return pokemon

func refresh_from_data() -> void:
	var upper_team:Array[Pokemon]
	var lower_team:Array[Pokemon]
	for slot in range(data.upper_team_states.size()):
		upper_team.append(get_pokemon(slot, true))
	for slot in range(data.lower_team_states.size()):
		lower_team.append(get_pokemon(slot, false))
	
	set_fighters(upper_team[0], upper_team[1], lower_team[0], lower_team[1])
	set_bank(upper_team, true)
	set_bank(lower_team, false)
	
	clear_field_effects()
	for effect in data.field_effects:
		add_field_effect(effect.name, effect.duration, effect.position)

func set_fighter(pokemon:Pokemon, slot:int) -> void:
	match(slot):
		0:
			$"Border/Mon-Field Split/VBoxContainer/MonGrid/FighterDisplay".set_fighter(pokemon)
		1:
			$"Border/Mon-Field Split/VBoxContainer/MonGrid/FighterDisplay2".set_fighter(pokemon)
		2:
			$"Border/Mon-Field Split/VBoxContainer/MonGrid/FighterDisplay3".set_fighter(pokemon)
		3:
			$"Border/Mon-Field Split/VBoxContainer/MonGrid/FighterDisplay4".set_fighter(pokemon)

func set_fighters(upper_left:Pokemon, upper_right:Pokemon, lower_left:Pokemon, lower_right:Pokemon) -> void:
	set_fighter(upper_left, 0)
	set_fighter(upper_right, 1)
	set_fighter(lower_left, 2)
	set_fighter(lower_right, 3)

func set_bank_slot(pokemon:Pokemon, slot:int, is_upper:bool) -> void:
	var display_slots : Array
	if is_upper:
		display_slots = $"Border/Mon-Field Split/VBoxContainer/UpperBank".get_children()
	else:
		display_slots = $"Border/Mon-Field Split/VBoxContainer/LowerBank".get_children()
	
	display_slots[slot].set_slot(pokemon)  

func set_bank(team:Array[Pokemon], is_upper:bool) -> void:
	var display_slots : Array
	if is_upper:
		display_slots = $"Border/Mon-Field Split/VBoxContainer/UpperBank".get_children()
	else:
		display_slots = $"Border/Mon-Field Split/VBoxContainer/LowerBank".get_children()  
	
	for slot in range(team.size()):
		display_slots[slot].set_slot(team[slot])

func add_field_effect(name:String, duration:int, position:int) -> void:
	var new_field = field_effect_scene.instantiate()
	new_field.set_values(name, duration)
	match(position):
		0:
			$"Border/Mon-Field Split/FieldEffects/UpperSide".add_child(new_field)
		1:
			$"Border/Mon-Field Split/FieldEffects/BothSides".add_child(new_field)
		2:
			$"Border/Mon-Field Split/FieldEffects/LowerSide".add_child(new_field)

func clear_field_effects():
	for effect in $"Border/Mon-Field Split/FieldEffects/UpperSide".get_children():
		$"Border/Mon-Field Split/FieldEffects/BothSides".remove_child(effect)
		effect.queue_free()
	for effect in $"Border/Mon-Field Split/FieldEffects/BothSides".get_children():
		$"Border/Mon-Field Split/FieldEffects/BothSides".remove_child(effect)
		effect.queue_free()
	for effect in $"Border/Mon-Field Split/FieldEffects/LowerSide".get_children():
		$"Border/Mon-Field Split/FieldEffects/BothSides".remove_child(effect)
		effect.queue_free()

func return_gamestate_data() -> GameStateData:
	return data
