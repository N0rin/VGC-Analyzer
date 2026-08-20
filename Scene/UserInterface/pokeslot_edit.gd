extends VBoxContainer

@export var slot := 0
@export var is_upper := true

signal pokemon_set(slot:int, is_upper:bool, index:int)
signal health_set(slot:int, is_upper:bool, value:int)
signal status_set(slot:int, is_upper:bool, status:String)
signal combat_info_set(slot:int, is_upper:bool, text:String)
signal terra_set(slot:int, is_upper:bool, is_terra:bool)

func _ready():
	if slot >= 2:
		$ActiveSetters.hide()

func _on_option_button_item_selected(index):
	emit_signal("pokemon_set", slot, is_upper, index)

func _on_spin_box_value_changed(value):
	emit_signal("health_set", slot, is_upper, value)

func _on_option_status_button_item_selected(index):
	var status = ""
	match(index):
		0:
			status = "brn"
		1:
			status = "par"
		2:
			status = "slp"
		3:
			status = "psn"
		4:
			status = "tox"
		5:
			status = "frz"
	emit_signal("status_set", slot, is_upper, status)

func _on_text_edit_text_changed():
	pass#emit_signal("combat_info_set", slot, is_upper, $ActiveSetters/TextEdit.text)

func _on_check_box_toggled(button_pressed):
	emit_signal("terra_set", slot, is_upper, button_pressed)

func set_state(selected_mon_state: PokemonState):
	$ActiveSetters/HBoxContainer/SpinBox.value = selected_mon_state.health
	$ActiveSetters/HBoxContainer/CheckBox.button_pressed = selected_mon_state.terracrystalized
	var status_id = 6
	match selected_mon_state.condition:
		"brn":
			status_id = 0
		"par":
			status_id = 1
		"slp":
			status_id = 2
		"psn":
			status_id = 3
		"tox":
			status_id = 4
		"frz":
			status_id = 5
	$ActiveSetters/HBoxContainer2/OptionButton.selected = status_id
	$ActiveSetters/TextEdit.text = selected_mon_state.combat_data

func set_menue(selected_mon_position:int, team_names:Array[String]) -> void:
	$OptionButton.clear()
	for slot in range(team_names.size()):
		$OptionButton.add_item(team_names[slot], slot)
	$OptionButton.selected = selected_mon_position
	


func _on_text_edit_focus_exited() -> void:
		emit_signal("combat_info_set", slot, is_upper, $ActiveSetters/TextEdit.text)
