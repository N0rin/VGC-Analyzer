extends VBoxContainer

@onready var reader = PasteReader.new()
@onready var import_edit = $TextEdit

signal team_selected(team: TeamData)



func _on_team_select_team_selected(team: TeamData) -> void:
	emit_signal("team_selected", team)


func _on_save_2_pressed() -> void:
	reader.convert_paste_data(import_edit.text)
