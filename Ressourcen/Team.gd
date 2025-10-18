extends Resource
class_name TeamData

@export_enum("All", "Reg A", "Reg B", "Reg C", "Reg D", "Reg E",
	"Reg F", "Reg G", "Reg H") var format = 0

@export var team_members:Array[PokemonData] = [null, null, null, null, null, null]
