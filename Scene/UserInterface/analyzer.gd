extends Control

signal back_to_main
signal continue_to_board(team1: TeamData, team2: TeamData)

func _on_back_pressed():
	emit_signal("back_to_main")


func _on_continue_pressed():
	emit_signal("continue_to_board", $MarginContainer/VBoxContainer/VSplitContainer/HSplitContainer/TeamSelect/TeamSelect.selected_team, 
		$MarginContainer/VBoxContainer/VSplitContainer/HSplitContainer/TeamSelect2/TeamSelect.selected_team)
