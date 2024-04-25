extends Control
class_name SearchOptionButton

signal item_selected(name:String)

var item_names: Array[String]
var selected: String = ""

func _on_button_toggled(toggled_on):
	if toggled_on:
		$PopupPanel.position = global_position + Vector2(0, size.y)
		$PopupPanel.size = Vector2(size.x, size.y * 8)
		$PopupPanel.show()
	else:
		$PopupPanel.hide()

func add_item(name):
	item_names.append(name)
	var button = SearchPopupButton.new()
	$PopupPanel/Box/Scroll/ButtonBox.add_child(button)
	button.text = name
	button.selected.connect(self._on_popup_button_pressed)

func clear():
	item_names.clear()
	$MainButton.button_pressed = false
	$MainButton.text = ""
	if $PopupPanel/Box/Scroll/ButtonBox.get_child_count() <= 0:
		return
	for button in $PopupPanel/Box/Scroll/ButtonBox.get_children():
		$PopupPanel/Box/Scroll/ButtonBox.remove_child(button)
		button.queue_free()


func _on_popup_button_pressed(name):
	$MainButton.text = name
	selected = name
	$MainButton.button_pressed = false
	$PopupPanel.hide()
	$PopupPanel/Box/Search.text = ""
	_on_search_text_changed("")
	emit_signal("item_selected", name)

func _on_search_text_changed(new_text):
	var buttons = $PopupPanel/Box/Scroll/ButtonBox.get_children()
	if new_text == "":
		for button in  buttons:
			button.show()
		return
	
	var matches: Array[String]
	for button in buttons:
		if new_text.to_lower() in button.text.to_lower():
			button.show()
		else:
			button.hide()
