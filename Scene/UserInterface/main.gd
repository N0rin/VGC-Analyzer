extends Control



func _on_button_analyzer_pressed():
	$Main.hide()
	$Analyzer.show()


func _on_button_quit_pressed():
	get_tree().quit()


func _on_button_calculations_pressed():
	$Main.hide()
	$Calculations.show()
