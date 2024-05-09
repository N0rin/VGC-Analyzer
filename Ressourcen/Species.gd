extends Resource
class_name Species

@export var name = ""
@export_group("Texture")
@export var texture_id : int
@export var texture_x : int
@export var texture_y : int
@export_group("Type")
@export_enum( "Normal", "Grass", "Fire", "Water", "Electric", "Fighting", "Flying", 
"Poison", "Ground", "Rock", "Bug", "Ice", "Psychic", "Ghost", "Dragon", "Dark",
"Steel", "Fairy" ) var main_type = "Normal"
@export_enum("None", "Normal", "Grass", "Fire", "Water", "Electric", "Fighting", "Flying", 
"Poison", "Ground", "Rock", "Bug", "Ice", "Psychic", "Ghost", "Dragon", "Dark",
"Steel", "Fairy" ) var secondary_type = "None"
@export_group("Abilities")
@export var ability1 : Ability
@export var ability2 : Ability
@export var ability3 : Ability
@export_group("Stats")
@export var hp = 0
@export var atk = 0
@export var def = 0
@export var spa = 0
@export var spd = 0
@export var spe = 0
@export_group("Other")
@export var weight = 60.0
