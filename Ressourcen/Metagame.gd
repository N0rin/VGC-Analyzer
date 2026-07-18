extends Resource
class_name Metagame

@export var name : String

@export_enum("All", "Reg M-A", "Reg M-B") var format = "All"

@export var included_pokemon : Array[Species]
