extends Control
class_name SearchOptionButton

func _on_button_toggled(toggled_on):
	if toggled_on:
		$PopupPanel.position = global_position + Vector2(0, size.y)
		$PopupPanel.size = Vector2(size.x, size.y * 8)
		$PopupPanel.show()
	else:
		$PopupPanel.hide()
