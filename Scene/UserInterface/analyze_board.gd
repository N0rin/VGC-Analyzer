extends Control

var battling_pokemon : Array[Pokemon] = [null, null, null, null, null, null, null, null]

func set_pokemon(board_slot:int, pokemon:Pokemon):
	battling_pokemon[board_slot] = pokemon
	match(board_slot):
		0, 1:
			$Interface/Board/GameState.set_fighter(pokemon, board_slot)
			$Interface/Board/GameState.set_bank_slot(pokemon, board_slot, true)
		2, 3:
			$Interface/Board/GameState.set_bank_slot(pokemon, board_slot, true)
		4, 5:
			$Interface/Board/GameState.set_fighter(pokemon, board_slot -2)
			$Interface/Board/GameState.set_bank_slot(pokemon, board_slot -4, false)
		6, 7:
			$Interface/Board/GameState.set_bank_slot(pokemon, board_slot -4, false)

func initialize_board():
	pass

func _on_pokemon_set(board_slot:int, team_slot:int):
	var pokemon : Pokemon
	if board_slot < 4:
		var team = $"Upper Team".get_children()
		if team.size() <= team_slot:
			pokemon = null
		else:
			pokemon = team[team_slot]
	else:
		var team = $"Lower Team".get_children()
		if team.size() <= team_slot:
			return
		pokemon = team[team_slot]
	set_pokemon(board_slot, pokemon)

func _on_health_set(board_slot:int, health:int):
	var pokemon = battling_pokemon[board_slot]
	pokemon.health = health
	set_pokemon(board_slot, pokemon)

func _on_status_set(board_slot:int, status:String):
	var pokemon = battling_pokemon[board_slot]
	pokemon.condition = status
	set_pokemon(board_slot, pokemon)

func _on_combat_info_set(board_slot, text):
	var pokemon = battling_pokemon[board_slot]
	pokemon.combat_data = text
	set_pokemon(board_slot, pokemon)

func _on_terra_set(board_slot, is_terra):
	var pokemon = battling_pokemon[board_slot]
	pokemon.terracrystalized = is_terra
	set_pokemon(board_slot, pokemon)

func _on_add_field_effect_pressed():
	var name = $"Interface/Right Menu/FieldEdit/LineEdit".text
	var duration = $"Interface/Right Menu/FieldEdit/SpinBox".value
	var side = $"Interface/Right Menu/FieldEdit/OptionButton".selected
	
	if name == "":
		return
	if duration < 0:
		return
	
	$"Interface/Board/GameState".add_field_effect(name, duration, side)

func _on_iterate_pressed():
	$"Interface/Board/GameState".iterate_field()

func _on_clear_all_pressed():
	$"Interface/Board/GameState".clear_field_effects()

func _on_title_edit_text_changed(new_text):
	$Interface/Board/GameState.state_name = new_text
