extends PanelContainer
class_name SetSelectionItem

@onready var subset_check_scene = preload("res://Scene/UserInterface/SubScenes/subset_check.tscn")

@onready var subset_container = $MarginContainer/VBoxContainer/Subsets/SubsetContainer
@onready var species_label = $MarginContainer/VBoxContainer/Species/Label

func create_subsets(pokemon_set_list: Array[PokemonData]):
	for pokemon_set in pokemon_set_list:
		var subset = subset_check_scene.instantiate()
		subset.set_pokemon_data(pokemon_set)
		subset_container.add_child(subset)
		subset.toggled.connect(_on_subset_toggled)

func load_data(species_name: String, pokemon_set_list: Array[PokemonData]):
	species_label.text = species_name
	create_subsets(pokemon_set_list)


func _on_check_box_toggled(toggled_on):
	for child in subset_container.get_children():
		child.set_toggle_state(toggled_on)

func _on_subset_toggled():
	var all_pressed = true
	var all_unpressed = true
	for child in subset_container.get_children():
		if child.get_toggle_state():
			all_unpressed = false
		else:
			all_pressed = false
	
	if all_pressed:
		$MarginContainer/VBoxContainer/Species/CheckBox.button_pressed = true
	if all_unpressed:
		$MarginContainer/VBoxContainer/Species/CheckBox.button_pressed = false
