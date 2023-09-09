extends Button

signal next_button_pressed(slot:int)

var index = 0

func _on_pressed():
	emit_signal("next_button_pressed", index)
