extends Control


func _on_button_pressed() -> void:
	for item in $MarginContainer/VBoxContainer/CoreUI/Right/Scroll/VBoxContainer.get_children():
		item.set_value($"MarginContainer/VBoxContainer/CoreUI/Left/Set Edit".get_pokemon_data())
