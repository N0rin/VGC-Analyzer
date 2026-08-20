extends HBoxContainer
class_name ActionInput

signal action_selected(index)
signal target_selected(target)

var pokemon : PokemonData
var reserve_names: Array

func set_pokemon(new_pokemon: PokemonData, new_reserve_names: Array) -> void:
	pokemon = new_pokemon
	reserve_names = new_reserve_names
	refresh_moves($Action, pokemon)

func refresh_moves(button: OptionButton, pokemon: PokemonData) -> void:
	button.clear()
	button.add_separator("")
	button.add_item("No Action")
	button.add_item("Switch")
	button.add_separator("Moves")
	for value in range(1,5):
		button.add_item(pokemon.get_move(value).name)
	button.select(0)

func set_selection(action: int, target: int) -> void:
	$Action.select(action)
	refresh_target(action)
	$Target.select(target)

func return_selection() -> Array[int]:
	return [$Action.selected, $Target.selected]


func refresh_target(action_id):
	$Target.clear()
	$Target.hide()
	match action_id:
		2:
			for name in reserve_names:
				$Target.add_item(name)
			$Target.selected = 0
			$Target.show()
		4, 5, 6, 7:
			if pokemon.get_move(action_id-3).targeting == "Single":
				$Target.add_item("Left")
				$Target.add_item("Right")
				$Target.add_item("Partner")
				$Target.selected = 0
				$Target.show()

func _on_action_item_selected(index: int) -> void:
	if $Action.selected == 1:
		$Action.selected = 0
	refresh_target(index)
	emit_signal("action_selected", index)


func _on_target_item_selected(index: int) -> void:
	emit_signal("target_selected", index)
