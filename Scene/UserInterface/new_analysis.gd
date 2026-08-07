extends Control

signal continue_to_board(team1: TeamData, team2: TeamData)
var team1: TeamData
var team2: TeamData    


func startup() -> void:
	show()

func _on_back_pressed():
	hide()

func _on_continue_pressed():
	emit_signal("continue_to_board", team1, team2) 

func _on_team_select_team_selected(team: TeamData) -> void:
	team1 = $MarginContainer/VBoxContainer/VSplitContainer/HSplitContainer/Team1/TeamSelect/TeamSelect.selected_team
	if team2:
		$MarginContainer/VBoxContainer/HBoxContainer/Continue.disabled = false
	
func _on_team_select_2_team_selected(team: TeamData) -> void:
	team2 = $MarginContainer/VBoxContainer/VSplitContainer/HSplitContainer/Team2/TeamSelect2/TeamSelect.selected_team
	if team1:
		$MarginContainer/VBoxContainer/HBoxContainer/Continue.disabled = false
