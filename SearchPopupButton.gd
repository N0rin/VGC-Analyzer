extends Button
class_name  SearchPopupButton

signal selected(name:String)

func _ready():
	pressed.connect(_on_pressed)

func _on_pressed():
	emit_signal("selected", text)
