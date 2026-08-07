extends Control
class_name TeamSelect
signal team_selected(team: TeamData)

const DATA_PATH = "res://Ressourcen/"

@onready var team_selector = $TeamSelector

@onready var team_list: Array[TeamData]
@onready var selected_team: TeamData

func _ready() -> void:
	load_into_list(team_list, "Teams")
	update_interface()

func load_into_list(list: Array, dirname: String):
	var dir = DirAccess.open(DATA_PATH)
	var file_list = dir.get_files_at(DATA_PATH + dirname)
	
	for filename in file_list:
		list.append(load(DATA_PATH + dirname + "/" + filename))

func find_by_name(list: Array, name: String):
	for thing in list:
		if thing.name == name:
			return thing

func update_interface():
	team_selector.clear()
	for team in team_list:
		team_selector.add_item(team.name)


func _on_team_selector_item_selected(name: String) -> void:
	selected_team = find_by_name(team_list, name)
	var counter = 0
	for icon: PokemonIcon in $"../IconContainer".get_children():
		var sprite_x = selected_team.team_members[counter].species.texture_x
		var sprite_y = selected_team.team_members[counter].species.texture_y
		var sprite_source = selected_team.team_members[counter].species.texture_id
		icon.set_sprite(sprite_x,sprite_y,sprite_source)
		counter += 1
	emit_signal("team_selected", selected_team)

func get_team() -> TeamData:
	return selected_team
