extends VBoxContainer
class_name ContextModifierSelection

@onready var context_modifier_scene = preload("res://Scene/UserInterface/SubScenes/modifier.tscn")

var selected_type = ""
var selected_modifier = ""
var selected_strength = 0

func modify_context(context: AttackContext) -> AttackContext:
	for item in $GridContainer.get_children():
		context = item.modify_context(context)
	return context

func clear_extras() -> void:
	reset_option($"HBoxContainer/Weather Select")
	reset_option($"HBoxContainer/Terrain Select")
	reset_option($"HBoxContainer/Ruin Select")
	reset_option($"HBoxContainer/Stat Select")
	reset_option($"HBoxContainer/Stat Strength Select")
	reset_option($"HBoxContainer/Screen Select")
	selected_modifier = ""
	selected_strength = 0

func reset_option(option_button: OptionButton):
	option_button.hide()
	option_button.selected = -1


func _on_modifier_type_item_selected(index: int) -> void:
	match index:
		0:
			selected_type = "Weather"
			clear_extras()
			$"HBoxContainer/Weather Select".show()
		1:
			selected_type = "Terrain"
			clear_extras()
			$"HBoxContainer/Terrain Select".show()
		2:
			selected_type = "Ruin Ability"
			clear_extras()
			$"HBoxContainer/Ruin Select".show()
		3:
			selected_type = "Helping Hand"
			clear_extras()
			selected_modifier = selected_type
		4:
			selected_type = "Stat Boost"
			clear_extras()
			$"HBoxContainer/Stat Select".show()
			$"HBoxContainer/Stat Strength Select".show()
		5:
			selected_type = "Screen"
			clear_extras()
			$"HBoxContainer/Screen Select".show()
		6:
			selected_type = "Friend Guard"
			clear_extras()
			selected_modifier = selected_type

func _on_weather_select_item_selected(index: int) -> void:
	match(index):
		0:
			selected_modifier = "Sun"
		1:
			selected_modifier = "Rain"
		2:
			selected_modifier = "Snow"
		3:
			selected_modifier = "Sand"

func _on_terrain_select_item_selected(index: int) -> void:
	match(index):
		0:
			selected_modifier = "Grassy"
		1:
			selected_modifier = "Electric"
		2:
			selected_modifier = "Psychic"
		3:
			selected_modifier = "Misty"

func _on_ruin_select_item_selected(index: int) -> void:
	match(index):
		0:
			selected_modifier = "Sword of Ruin"
		1:
			selected_modifier = "Beads of Ruin"
		2:
			selected_modifier = "Vessel of Ruin"
		3:
			selected_modifier = "Tablets of Ruin"

func _on_stat_select_item_selected(index: int) -> void:
	match(index):
		0:
			selected_modifier = "Atk"
		1:
			selected_modifier = "Def"
		2:
			selected_modifier = "SpA"
		3:
			selected_modifier = "SpD"

func _on_stat_strength_select_item_selected(index: int) -> void:
	if index <= 5:
		selected_strength = 6 - index
	else:
		selected_strength = 5 - index

func _on_screen_select_item_selected(index: int) -> void:
	match(index):
		0:
			selected_modifier = "Aurora Veil"
		1:
			selected_modifier = "Light Screen"
		2:
			selected_modifier = "Reflect"


func _on_button_pressed() -> void:
	if selected_modifier == "":
			return
	elif selected_type == "Stat Boost":
		if selected_strength == 0:
			return
	
	var context_modifer = context_modifier_scene.instantiate()
	context_modifer.set_modifier(selected_type, selected_modifier, selected_strength)
	$GridContainer.add_child(context_modifer)
