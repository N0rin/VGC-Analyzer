extends Control

@onready var team_select = $MarginContainer/VBoxContainer/CoreUI/Left/TeamSelect
@onready var move_list = $MarginContainer/VBoxContainer/CoreUI/Middle/MiddleScroll/MoveList
@onready var defender = Pokemon.new()

@onready var team_move_item_scene = preload("res://Scene/UserInterface/SubScenes/team_move_item.tscn")

func _ready() -> void:
	defender.state = PokemonState.new()
	defender.data = PokemonData.new()
	defender.data.species = Species.new()
	defender.data.ability = Ability.new()
	defender.data.item = Item.new()

func update_middle():
	clear_middle_selection()
	var context = AttackContext.new()
	var team_index = 0
	var team_move_list: Array[TeamMoveItem]
	for team_member_data: PokemonData in get_team_data():
	
		var test_pokemon = Pokemon.new()
		test_pokemon.state = PokemonState.new()
		test_pokemon.data = team_member_data
		context.attacker = test_pokemon
		context.defender = defender
		
		for move_value in range(1,5):
				context.used_attack = move_value
				if context.get_move():
					match(context.get_move().category):
						"Physical", "Special":
							for attack_variant in get_attack_variants(context):
								var team_move_item = team_move_item_scene.instantiate()
								team_move_item.modulate = get_member_color(team_index)
								team_move_item.load_attack(context)
								team_move_list.append(team_move_item)
		team_index += 1
	team_move_list.sort_custom(func(a,b): return a.value > b.value)
	
	for team_move_item in team_move_list:
		move_list.add_child(team_move_item)

func clear_middle_selection():
	for child in move_list.get_children():
		move_list.remove_child(child)
		child.queue_free()

func get_team_data() -> Array[PokemonData]:
	return team_select.get_team().team_members


func _on_team_select_team_selected(team: TeamData) -> void:
	for item in $MarginContainer/VBoxContainer/CoreUI/Right/Scroll/VBoxContainer.get_children():
		
		item.set_value_team(team)
		update_middle()

func get_member_color(index : int) -> Color:
	match(index):
		1:
			return Color("57af76")
		2:
			return Color("ed6196")
		3:
			return Color("669ae6")
		4:
			return Color("da7e4b")
		5:
			return Color("af7ceb")
		_:
			return Color("999999")

func get_attack_variants(context: AttackContext) -> Array[AttackContext]:
	return [context]
