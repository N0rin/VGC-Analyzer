extends Control
class_name LoadAnalysis

signal load_battle_data(battle_data: GameData)

const SAVE_GAME_BASE_PATH := "user://games/"
@onready var load_analysis_item_scene = preload("res://Scene/UserInterface/SubScenes/load_analysis_item.tscn")
@onready var load_selection = $MarginContainer/VBoxContainer/HBoxContainer/ScrollContainer/VBoxContainer
@onready var saveloader = SaveLoader.new()

var file_list: Array
var loaded_save: GameData

func startup() -> void:
	DirAccess.open(SAVE_GAME_BASE_PATH)
	var file_list = DirAccess.get_files_at(SAVE_GAME_BASE_PATH)
	
	for filename in file_list:
		var load_analysis_item: LoadAnalysisItem = load_analysis_item_scene.instantiate()
		load_selection.add_child(load_analysis_item)
		load_analysis_item.set_filename(filename)
		load_analysis_item.chosen_file.connect(_on_file_chosen)

	show()

func _on_file_chosen(filename: String):
	loaded_save = saveloader.load_data(filename)
	var counter = 0
	for icon: PokemonIcon in $MarginContainer/VBoxContainer/HBoxContainer/Overview/IconContainer1.get_children():
		var sprite_x = loaded_save.upper_team[counter].species.texture_x
		var sprite_y = loaded_save.upper_team[counter].species.texture_y
		var sprite_source = loaded_save.upper_team[counter].species.texture_id
		icon.set_sprite(sprite_x,sprite_y,sprite_source)
		counter += 1
	counter = 0
	for icon: PokemonIcon in $MarginContainer/VBoxContainer/HBoxContainer/Overview/IconContainer2.get_children():
		var sprite_x = loaded_save.lower_team[counter].species.texture_x
		var sprite_y = loaded_save.lower_team[counter].species.texture_y
		var sprite_source = loaded_save.lower_team[counter].species.texture_id
		icon.set_sprite(sprite_x,sprite_y,sprite_source)
		counter += 1
	


func _on_back_pressed() -> void:
	hide()


func _on_load_pressed() -> void:
	emit_signal("load_battle_data", loaded_save)
