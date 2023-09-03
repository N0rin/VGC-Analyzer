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
