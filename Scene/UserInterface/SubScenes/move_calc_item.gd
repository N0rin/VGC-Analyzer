extends PanelContainer
class_name MoveCalcItem

var max_damage = 0
var min_damage = 0

func load_attack(context: AttackContext):
	$MarginContainer/HBoxContainer/Description.text = AttackDescription.create_description(context)
	context.damage_roll = 0
	max_damage = damage_calculation.calculate_percentage(context)
	context.damage_roll = 15
	min_damage = damage_calculation.calculate_percentage(context)
	
	$MarginContainer/HBoxContainer/Maximum.text = "%.d%%" % max_damage
	$MarginContainer/HBoxContainer/Minimum.text = "%.d%%" % min_damage

func _on_remove_button_pressed():
	hide()
