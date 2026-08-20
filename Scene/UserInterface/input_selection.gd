extends HBoxContainer
class_name analyze_move_input

signal action_selected
signal target_selected

var actions_selected: Array[int]= [0,0]
var targets_selected: Array[int]= [0,0]

func set_pokemon(pokemon: PokemonData, reserve_names: Array, is_left = true) -> void:
	if is_left:
		$LeftInput.set_pokemon(pokemon, reserve_names)
	else:
		$RightInput.set_pokemon(pokemon, reserve_names)

func set_input(actions: Array[int], targets: Array[int]) -> void:
	$LeftInput.set_selection(actions[0], targets[0])
	$RightInput.set_selection(actions[1], targets[1])

func _on_left_input_action_selected(index: Variant) -> void:
	actions_selected[0] = index
	emit_signal("action_selected")

func _on_right_input_action_selected(index: Variant) -> void:
	actions_selected[1] = index
	emit_signal("action_selected")

func _on_left_input_target_selected(target: Variant) -> void:
	targets_selected[0] = target
	emit_signal("target_selected")

func _on_right_input_target_selected(target: Variant) -> void:
	targets_selected[1] = target
	emit_signal("target_selected")

func get_selected_actions() -> Array[int]:
	return actions_selected

func get_selected_targets() -> Array[int]:
	return targets_selected
