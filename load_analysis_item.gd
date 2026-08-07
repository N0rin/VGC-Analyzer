extends Button
class_name LoadAnalysisItem

@onready var filename: String

signal chosen_file(filename: String)

func _on_pressed() -> void:
	emit_signal("chosen_file",filename)

func set_filename(new_filename: String) -> void:
	filename = new_filename.erase(new_filename.findn(".json"), 5)
	text = filename
