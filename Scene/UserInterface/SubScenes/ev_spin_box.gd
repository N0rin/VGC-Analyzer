extends SpinBox
class_name EvSpinBox

func _on_value_changed(value):
	if value > 0:
		set_custom_arrow_step(8)
	if value < 4:
		set_custom_arrow_step(4)

func _on_gui_input(event):
	if event is InputEventMouseButton:
		match(event.button_index):
			MOUSE_BUTTON_WHEEL_UP:
				if (int(value) - 4) % 8 != 0:
					value -= (int(value) - 4) % 8
			MOUSE_BUTTON_WHEEL_DOWN:
				if (int(value) - 4) % 8 != 0:
					value -= (int(value) - 4) % 8
				if value == 4:
					value = 0
