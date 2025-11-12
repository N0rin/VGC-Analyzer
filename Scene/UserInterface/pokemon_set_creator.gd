extends Control

const DATA_PATH = "res://Ressourcen/"

@onready var set_edit = $"MarginContainer/VBoxContainer/CoreUI/Middle/Set Edit"
@onready var new_set_name = $PopupPanel/MarginContainer/VBoxContainer/HBoxContainer2/TextEdit

#Loading
func startup():
	set_edit.load_saved_pokemon_data()
	show()

#Saving
func save_set(set_name: String):
	var pokemon_set : PokemonData = set_edit.get_pokemon_data()
	pokemon_set.name = set_name
	pokemon_set.format = $PopupPanel/MarginContainer/VBoxContainer/HBoxContainer2/FormatSelect.selected
	var resource_path = "%sPokemonSets/%s_%s.tres" % [DATA_PATH, pokemon_set.species.name.format("_", " "), set_name.format("_", " ")]
	var result = ResourceSaver.save(pokemon_set, resource_path)
	assert(result == OK)
	
	set_edit.pokemon_set_list.append(pokemon_set)

#Signal Reactions
func _on_back_pressed():
	hide()
	set_edit.clear()

func _on_save_pressed():
	$PopupPanel.show()

func _on_confirm_pressed():
	if new_set_name.text != "":
		save_set(new_set_name.text)
		$PopupPanel.hide()

func _on_cancel_pressed():
	$PopupPanel.hide()
