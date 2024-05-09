extends PanelContainer
class_name MoveCalcItem

func create_description(context: AttackContext):
	var attacker_boost = ""
	var attacker_training = ""
	var attacker_item = ""
	var attacker_name = ""
	var attacker = attacker_boost + attacker_training + attacker_item + attacker_name
	
	var attack_booster = ""
	var attack_name = ""
	var attack_extra = ""
	var attack = attack_booster + attack_name + attack_extra
	
	var defender_boost = ""
	var defender_training = ""
	var defender_name = ""
	var defender = defender_boost + defender_training + defender_name
	
	var screen = ""
	var friend_guard = ""
	var terrain = ""
	var weather = ""
	var environment = screen + friend_guard + terrain + weather
	
	var description = attacker + attack + " vs. " + defender + environment
	$MarginContainer/HBoxContainer/Description.text = description
	
