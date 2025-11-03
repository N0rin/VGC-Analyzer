extends PanelContainer
class_name ContextModifier

var type = ""
var modifier_name = ""
var strength = 1

func set_modifier(new_type, new_name, new_strength) -> void:
	type = new_type
	modifier_name = new_name
	strength = new_strength
	
	
	if type == "Stat Boost":
		$Components/Label.text = "%d+ %s" % [strength,modifier_name]
	elif type == "Terrain":
		$Components/Label.text = modifier_name + " Terrain"
	else:
		$Components/Label.text = modifier_name

func modify_context(context: AttackContext) -> AttackContext:
	match type:
		"Helping Hand":
			context.helping_hand = true
		"Friend Guard":
			context.friend_guard = true
		"Screen":
			context.screen = modifier_name
		"Weather":
			context.weather = modifier_name
		"Terrain":
			context.terrain = modifier_name
		"Ruin Ability":
			match modifier_name:
				"Sword of Ruin":
					context.ruin_sword = true
				"Beads of Ruin":
					context.ruin_beads = true
				"Vessel of Ruin":
					context.ruin_vessel = true
				"Tablets of Ruin":
					context.ruin_tablets = true
		"Stat Boost":
			match modifier_name:
				"Atk":
					context.attacker.state.attack_stack += strength
				"SpA":
					context.attacker.state.special_attack_stack += strength
				"Def":
					context.defender.state.defense_stack += strength
				"SpD":
					context.defender.state.defense_stack += strength
	
	return context


func _on_button_pressed() -> void:
	get_parent().remove_child(self)
	queue_free()
