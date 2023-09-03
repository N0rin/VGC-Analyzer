extends VBoxContainer

@export var slot := 0

signal pokemon_set
signal health_set
signal status_set

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
