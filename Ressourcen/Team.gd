extends Resource
class_name TeamData

@export var name = "new Team"

@export_enum("Reg MB", "Reg MA") var format = 0

@export var team_members:Array[PokemonData] = [null, null, null, null, null, null]
