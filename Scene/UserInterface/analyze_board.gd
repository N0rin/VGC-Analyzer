extends Control
@onready var gamestate_interface:GameStateInterface = $Interface/Board/GameState
@onready var active_game_state:= GameStateData.new()
@onready var gamestate_position:Array[int] = []
@onready var next_button_scene = load("res://Scene/UserInterface/NextButton.tscn")
@onready var saveloader = SaveLoader.new()

@export var battle_data:GameData

func _ready():
	initialize_board()
	set_edit_names()

func initialize_board():
	gamestate_interface.set_teams(battle_data.upper_team, battle_data.lower_team)
	refresh_game_state()

func set_edit_names() -> void:
	var upper_edit = $"Interface/Right Menu/UpperTeamEdit"
	var lower_edit = $"Interface/Right Menu/LowerTeamEdit"
	var upper_team_names:Array[String]
	var lower_team_names:Array[String]
	
	for slot in range(battle_data.upper_team.size()):
		var pokemon: PokemonData = battle_data.upper_team[active_game_state.upper_team_lineup[slot]]
		if pokemon == null:
			continue
		upper_team_names.append(pokemon.species.name)
	for slot in range(battle_data.lower_team.size()):
		var pokemon: PokemonData = battle_data.lower_team[active_game_state.lower_team_lineup[slot]]
		if pokemon == null:
			continue
		lower_team_names.append(pokemon.species.name)
	
	upper_edit.get_node("Slot1").set_menue(0, upper_team_names)
	upper_edit.get_node("Slot2").set_menue(1, upper_team_names)
	upper_edit.get_node("Slot3").set_menue(2, upper_team_names)
	upper_edit.get_node("Slot4").set_menue(3, upper_team_names)
	lower_edit.get_node("Slot5").set_menue(0, lower_team_names)
	lower_edit.get_node("Slot6").set_menue(1, lower_team_names)
	lower_edit.get_node("Slot7").set_menue(2, lower_team_names)
	lower_edit.get_node("Slot8").set_menue(3, lower_team_names)

func refresh_game_state() -> void:
	gamestate_interface.set_data(active_game_state)
	save_changes()

func save_changes() -> void:
	if gamestate_position.is_empty():
		battle_data.game_state_data = active_game_state
	else:
		battle_data.game_state_data.edit_child_at_path(gamestate_position.duplicate(), active_game_state)

func add_new_state() -> void:
	save_changes()
	var children_position = active_game_state.children.size()
	battle_data.game_state_data.add_child_at_path(gamestate_position.duplicate(), make_gamestate_child())
	gamestate_position.append(children_position)
	load_gamestate(gamestate_position)

func make_gamestate_child() -> GameStateData:
	var new_gamestate:= GameStateData.new()
	new_gamestate.parent = active_game_state
	new_gamestate.state_turn = active_game_state.state_turn
	for effect in active_game_state.field_effects:
		var new_effect:= FieldEffectData.new()
		new_effect.name = effect.name
		new_effect.duration = effect.duration
		new_effect.position = effect.position
		new_gamestate.field_effects.append(new_effect)
	new_gamestate.upper_team_lineup = active_game_state.upper_team_lineup.duplicate()
	new_gamestate.lower_team_lineup = active_game_state.lower_team_lineup.duplicate()
	for slot in range(6):
		new_gamestate.upper_team_states[slot] = PokemonState.new()
		new_gamestate.upper_team_states[slot].combat_data = active_game_state.upper_team_states[slot].combat_data
		new_gamestate.upper_team_states[slot].condition = active_game_state.upper_team_states[slot].condition
		new_gamestate.upper_team_states[slot].health = active_game_state.upper_team_states[slot].health
		new_gamestate.upper_team_states[slot].terracrystalized = active_game_state.upper_team_states[slot].terracrystalized
		
		new_gamestate.lower_team_states[slot] = PokemonState.new()
		new_gamestate.lower_team_states[slot].combat_data = active_game_state.lower_team_states[slot].combat_data
		new_gamestate.lower_team_states[slot].condition = active_game_state.lower_team_states[slot].condition
		new_gamestate.lower_team_states[slot].health = active_game_state.lower_team_states[slot].health
		new_gamestate.lower_team_states[slot].terracrystalized = active_game_state.lower_team_states[slot].terracrystalized
	
	new_gamestate.iterate_field()
	
	return new_gamestate

func load_gamestate(tree_path: Array[int]) -> void:
	active_game_state = battle_data.game_state_data.get_child_at_path(tree_path.duplicate())
	$Interface/Board/Title/TitleEdit.text = active_game_state.state_name
	$Interface/Board/Title/Label2.text = str(active_game_state.state_turn)
	$Interface/Board/Commentary.text = active_game_state.commentary
	
	refresh_navigation_buttons()
	refresh_game_state()

func refresh_navigation_buttons() -> void:
	$Interface/LeftMenu/Previous.show()
	if active_game_state.parent == null:
		$Interface/LeftMenu/Previous.hide()
	
	for button in $Interface/LeftMenu/NextSlots.get_children():
		$Interface/LeftMenu/NextSlots.remove_child(button)
		button.queue_free()
	
	for index in range(active_game_state.children.size()):
		var new_button = next_button_scene.instantiate()
		new_button.index = index
		new_button.next_button_pressed.connect(_on_next_pressed)
		new_button.text = "Outcome " + str(index+1)
		$Interface/LeftMenu/NextSlots.add_child(new_button)

func _on_pokemon_set(board_slot:int, is_upper:bool, team_slot:int, ):
	active_game_state.switch_position(board_slot, team_slot, is_upper)
	set_edit_names()
	refresh_game_state()

func _on_health_set(board_slot:int, is_upper:bool, health:int):
	if is_upper:
		active_game_state.upper_team_states[board_slot].health = health
	else:
		active_game_state.lower_team_states[board_slot].health = health
	refresh_game_state()

func _on_status_set(board_slot:int, is_upper:bool, status:String):
	if is_upper:
		active_game_state.upper_team_states[board_slot].condition = status
	else:
		active_game_state.lower_team_states[board_slot].condition = status
	refresh_game_state()

func _on_combat_info_set(board_slot:int, is_upper:bool, text:String):
	if is_upper:
		active_game_state.upper_team_states[board_slot].combat_data = text
	else:
		active_game_state.lower_team_states[board_slot].combat_data = text
	refresh_game_state()

func _on_terra_set(board_slot:int, is_upper:bool, is_terra:bool):
	if is_upper:
		active_game_state.upper_team_states[board_slot].terracrystalized = is_terra
	else:
		active_game_state.lower_team_states[board_slot].terracrystalized = is_terra
	refresh_game_state()

func _on_add_field_effect_pressed():
	var field_effect:= FieldEffectData.new()
	field_effect.name = $"Interface/Right Menu/FieldEdit/LineEdit".text
	field_effect.duration = $"Interface/Right Menu/FieldEdit/SpinBox".value
	field_effect.position = $"Interface/Right Menu/FieldEdit/OptionButton".selected
	
	if field_effect.name == "":
		return
	if field_effect.duration < 0:
		return
	
	active_game_state.field_effects.append(field_effect)
	refresh_game_state()

func _on_iterate_pressed():
	active_game_state.iterate_field()
	refresh_game_state()

func _on_clear_all_pressed():
	active_game_state.field_effects.clear()
	refresh_game_state()

func _on_title_edit_text_changed(new_text):
	active_game_state.state_name = new_text

func _on_commentary_lines_edited_from(from_line, to_line):
	active_game_state.commentary = $Interface/Board/Commentary.text

func _on_add_state_pressed():
	add_new_state()

func _on_previous_pressed():
	gamestate_position.pop_back()
	load_gamestate(gamestate_position)

func _on_next_pressed(index:int):
	gamestate_position.append(index)
	load_gamestate(gamestate_position)

func _on_load_pressed():
	battle_data = saveloader.load_data($Interface/LeftMenu/Filename.text)
	load_gamestate([])

func _on_save_pressed():
	save_changes()
	saveloader.save_data($Interface/LeftMenu/Filename.text, battle_data)

