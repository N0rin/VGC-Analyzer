extends Control

signal back_to_main


func _on_back_pressed():
	emit_signal("back_to_main")
