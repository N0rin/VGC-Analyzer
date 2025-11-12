extends PanelContainer
class_name TeamMoveItem

var value = 0

func load_attack(attack_context):
	$MarginContainer/HBoxContainer/Description.text = AttackDescription.create_team_overview_description(attack_context)
	value = damage_calculation.calculate_complete_damage(attack_context, true)
	$MarginContainer/HBoxContainer/Value.text = str(value)


func _on_button_pressed() -> void:
	hide()
