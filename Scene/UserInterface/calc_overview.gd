extends Control

const DATA_PATH = "res://Ressourcen/"

@onready var overview_item_scene = preload("res://Scene/UserInterface/SubScenes/pokemon_overview_item.tscn")

var pokemon_list: Array[Species]

@onready var list = $MarginContainer/VBoxContainer/CoreUI/Middle/ScrollContainer/VBoxContainer

func _ready():
	load_into_list(pokemon_list, "Species")
	update_list("Total")


func load_into_list(list: Array, dirname: String):
	var dir = DirAccess.open(DATA_PATH)
	var file_list = dir.get_files_at(DATA_PATH + dirname)
	
	for filename in file_list:
		list.append(load(DATA_PATH + dirname + "/" + filename))

func update_list(method: String):
	clear_list()
	
	var item_list : Array[PokemonOverviewItem]
	for pokemon in pokemon_list:
		if pokemon.restriction >= 1:
			continue
		var list_item = overview_item_scene.instantiate()
		list_item.pokemon_data = pokemon
		item_list.append(list_item)
	
	sort_item_list(method, item_list)
	for item in item_list:
		list.add_child(item)
		item.load_pokemon()

func clear_list():
	for child in list.get_children():
		list.remove_child(child)
		child.queue_free()

func sort_item_list(method: String, item_list: Array):
	var factors = [1,1,1,1]
	factors[0] = $MarginContainer/VBoxContainer/CoreUI/Middle/HBoxContainer/FactorOffense.value
	factors[1] = $MarginContainer/VBoxContainer/CoreUI/Middle/HBoxContainer/FactorDefense.value
	factors[2] = $MarginContainer/VBoxContainer/CoreUI/Middle/HBoxContainer/FactorSpDefense.value
	factors[3] = $MarginContainer/VBoxContainer/CoreUI/Middle/HBoxContainer/FactorSpeed.value
	var compare_func : Callable
	match method:
		"Total":
			compare_func = func(a,b): return a.get_total(factors) > b.get_total(factors)
		"Offense":
			compare_func = func(a,b): return a.get_offense() > b.get_offense()
		"PhysicalDefense":
			compare_func = func(a,b): return a.get_physical_defense() > b.get_physical_defense()
		"SpecialDefense":
			compare_func = func(a,b): return a.get_special_defense() > b.get_special_defense()
		"Speed":
			compare_func = func(a,b): return a.get_speed() > b.get_speed()
		
	item_list.sort_custom(compare_func)


func _on_filter_pressed():
	update_list("Offense")


func _on_filter_2_pressed():
	update_list("PhysicalDefense")


func _on_filter_3_pressed():
	update_list("SpecialDefense")


func _on_filter_4_pressed():
	update_list("Speed")


func _on_filter_5_pressed():
	update_list("Total")


func _on_factor_value_changed(value): # Sehr hässliche Lösung, um Label zu setzen und ready Schwierigkeit zu umgehen
	var factors = [1,1,1,1]
	factors[0] = $MarginContainer/VBoxContainer/CoreUI/Middle/HBoxContainer/FactorOffense.value
	factors[1] = $MarginContainer/VBoxContainer/CoreUI/Middle/HBoxContainer/FactorDefense.value
	factors[2] = $MarginContainer/VBoxContainer/CoreUI/Middle/HBoxContainer/FactorSpDefense.value
	factors[3] = $MarginContainer/VBoxContainer/CoreUI/Middle/HBoxContainer/FactorSpeed.value
	update_list("Total")
	for item in list.get_children():
		item.set_total(item.get_total(factors))
