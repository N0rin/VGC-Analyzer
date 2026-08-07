extends Control

signal back_to_main
signal to_new_analysis
signal to_load_analysis


func _on_back_pressed() -> void:
	emit_signal("back_to_main")
	
func _on_button_new_analysis_pressed() -> void:
	emit_signal("to_new_analysis")

func _on_button_load_analysis_pressed() -> void:
	emit_signal("to_load_analysis")
