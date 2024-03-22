extends Control

signal back_to_main
signal continue_to_board

func _on_back_pressed():
	emit_signal("back_to_main")


func _on_continue_pressed():
	emit_signal("continue_to_board")
