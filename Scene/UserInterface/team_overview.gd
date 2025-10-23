extends Control

@onready var team_select = $MarginContainer/VBoxContainer/CoreUI/Left/TeamSelect

func _on_button_pressed() -> void:
	for item in $MarginContainer/VBoxContainer/CoreUI/Right/Scroll/VBoxContainer.get_children():
		
		item.set_value_team(team_select.get_team())
