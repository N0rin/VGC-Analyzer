extends Control

signal back_to_main
signal create_set

func _on_button_back_pressed():
	emit_signal("back_to_main")


func _on_button_set_pressed():
	emit_signal("create_set")
