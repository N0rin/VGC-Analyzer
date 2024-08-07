extends Resource
class_name Metagame

@export var name : String

@export_enum("All", "Reg A", "Reg B", "Reg C", "Reg D", "Reg E",
	"Reg F", "Reg G", "Reg H") var format = 0

@export var included_pokemon : Array[Species]
