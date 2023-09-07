extends VBoxContainer

@export var slot := 0

signal pokemon_set(slot:int, index:int)
signal health_set(slot:int, value:int)
signal status_set(slot:int, status:String)
signal combat_info_set(slot:int, text:String)
signal terra_set(slot:int, is_terra:bool)

func _on_option_button_item_selected(index):
	emit_signal("pokemon_set", slot, index)

func _on_spin_box_value_changed(value):
	if $OptionButton.selected == -1:
		return
	emit_signal("health_set", slot, value)

func _on_option_status_button_item_selected(index):
	if $OptionButton.selected == -1:
		return
	
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
	emit_signal("status_set", slot, status)


func _on_text_edit_text_changed():
	if $OptionButton.selected == -1:
		return
	
	emit_signal("combat_info_set", slot, $TextEdit.text)


func _on_check_box_toggled(button_pressed):
	emit_signal("terra_set", slot, button_pressed)
