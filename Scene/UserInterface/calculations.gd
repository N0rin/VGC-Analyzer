extends Control

signal back_to_main
signal to_meta
signal to_matchup
signal to_damage

func _on_button_back_pressed():
	emit_signal("back_to_main")


func _on_button_meta_pressed():
	emit_signal("to_meta")


func _on_button_matchup_pressed():
	emit_signal("to_matchup")


func _on_button_damage_pressed():
	emit_signal("to_damage")
