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
		$TextEdit.hide()

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
	emit_signal("combat_info_set", slot, is_upper, $TextEdit.text)

func _on_check_box_toggled(button_pressed):
	emit_signal("terra_set", slot, is_upper, button_pressed)

func set_menue(selected_mon:int, team_names:Array[String]) -> void:
	$OptionButton.clear()
	for slot in range(team_names.size()):
		$OptionButton.add_item(team_names[slot], slot)
	$OptionButton.selected = selected_mon
