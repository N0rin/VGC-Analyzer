extends VBoxContainer

signal team_selected(team: TeamData)



func _on_team_select_team_selected(team: TeamData) -> void:
	emit_signal("team_selected", team)
