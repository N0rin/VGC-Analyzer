extends PanelContainer
class_name MoveCalcItem

func load_attack(context: AttackContext):
	$MarginContainer/HBoxContainer/Description.text = AttackDescription.create_description(context)


func _on_remove_button_pressed():
	hide()
