extends Control

@onready var move_calc_item_scene = preload("res://Scene/UserInterface/SubScenes/move_calc_item.tscn")

var pokemon_team_list: Array[TeamData]

var is_left_attacker = true

@onready var left_team_select : TeamSelect = $MarginContainer/VBoxContainer/CoreUI/Left/TeamSelect
@onready var right_team_select : TeamSelect = $MarginContainer/VBoxContainer/CoreUI/Right/TeamSelect
@onready var middle_move_list = $MarginContainer/VBoxContainer/CoreUI/Middle/MiddleScroll/MoveList

#Loading
func startup() -> void:
	show()

#Interface
func update_move_calcs() -> void:
	clear_move_list()
	if left_team_select.get_team() and right_team_select.get_team():
		var left_team : TeamData = left_team_select.get_team()
		var right_team : TeamData = right_team_select.get_team()
		var move_calc_list: Array[MoveCalcItem]
		
		for left_pokemon_data in left_team.team_members:
			var left_pokemon = Pokemon.new()
			left_pokemon.state = PokemonState.new()
			left_pokemon.data = left_pokemon_data
			
			var left_mon_move_list : Array[MoveCalcItem]
			for right_pokemon_data in right_team.team_members:
				var right_pokemon = Pokemon.new()
				right_pokemon.state = PokemonState.new()
				right_pokemon.data = right_pokemon_data
				
				var context = AttackContext.new()
				
				if is_left_attacker:
					context.attacker = left_pokemon
					context.defender = right_pokemon
				else:
					context.attacker = right_pokemon
					context.defender = left_pokemon
					
				var move_list : Array[MoveCalcItem]
					
				for move_value in range(1,5):
					context.used_attack = move_value
					if context.get_move():
						match(context.get_move().category):
							"Physical", "Special":
								var move_calc_item = move_calc_item_scene.instantiate()
								#context = $MarginContainer/VBoxContainer/CoreUI/Left/Factors.modify_context(context)
								if context.get_move().targeting == "All" or context.get_move().targeting == "Enemies":
									context.is_spread = true
								else:
									context.is_spread = false
									
								move_calc_item.load_attack(context)
								move_list.append(move_calc_item)
				left_mon_move_list.append_array(move_list)
			left_mon_move_list.sort_custom(func(a,b): return a.max_damage > b.max_damage)
			move_calc_list.append_array(left_mon_move_list)
		
		move_calc_list.sort_custom(func(a,b): return a.max_damage > b.max_damage)
		for move_calc_item: MoveCalcItem in move_calc_list:
			if move_calc_item.min_damage >= 100:
				middle_move_list.add_child(move_calc_item)
		
		

func clear_move_list() -> void:
	for child in middle_move_list.get_children():
		middle_move_list.remove_child(child)
		child.queue_free()

#Signal Reactions
func _on_team_select_team_selected(team: TeamData) -> void:
	update_move_calcs()


func _on_toggle_attacker_pressed() -> void:
	if is_left_attacker:
		is_left_attacker = false
		$MarginContainer/VBoxContainer/Bottom/ToggleAttacker.text = " Defense "
	else:
		is_left_attacker = true
		$MarginContainer/VBoxContainer/Bottom/ToggleAttacker.text = " Offense "
	update_move_calcs()
