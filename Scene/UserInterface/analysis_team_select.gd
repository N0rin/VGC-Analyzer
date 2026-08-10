extends VBoxContainer

@onready var reader = PasteReader.new()
@onready var import_edit = $TextEdit

signal team_selected(team: TeamData)



func _on_team_select_team_selected(team: TeamData) -> void:
	set_team(team)

func _on_save_2_pressed() -> void:
	set_team(reader.convert_paste_data(import_edit.text))

func set_team(team: TeamData) -> void:
	for i in $"IconContainer".get_children().size():
		var sprite_x = team.team_members[i].species.texture_x
		var sprite_y = team.team_members[i].species.texture_y
		var sprite_source = team.team_members[i].species.texture_id
		$"IconContainer".get_children()[i].set_sprite(sprite_x,sprite_y,sprite_source)
	
	emit_signal("team_selected", team)
