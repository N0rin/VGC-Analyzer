extends Control

signal back_to_main


func _on_button_back_pressed():
	emit_signal("back_to_main")
