extends PanelContainer
class_name TeamMoveItem

var value = 0

func load_attack(attack_context):
	$MarginContainer/HBoxContainer/Description.text = AttackDescription.create_team_overview_description(attack_context)
	value = damage_calculation.calculate_move_power(attack_context)
	$MarginContainer/HBoxContainer/Value.text = str(value)
