extends Resource
class_name TeamData

@export var name = "new Team"

@export_enum("Reg A", "Reg B", "Reg C", "Reg D", "Reg E",
	"Reg F", "Reg G", "Reg H") var format = 7

@export var team_members:Array[PokemonData] = [null, null, null, null, null, null]
