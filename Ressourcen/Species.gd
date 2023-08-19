extends Resource
class_name Species

@export var sprite : Sprite2D
@export var name = ""
@export_enum( "Normal", "Grass", "Fire", "Water", "Electric", "Fighting", "Flying", 
"Poison", "Ground", "Rock", "Bug", "Ice", "Psychic", "Ghost", "Dragon", "Dark",
"Steel", "Fairy" ) var main_type = "Normal"
@export_enum("None", "Normal", "Grass", "Fire", "Water", "Electric", "Fighting", "Flying", 
"Poison", "Ground", "Rock", "Bug", "Ice", "Psychic", "Ghost", "Dragon", "Dark",
"Steel", "Fairy" ) var secondary_type = "None"
@export var hp = 0
@export var atk = 0
@export var def = 0
@export var spa = 0
@export var spd = 0
@export var spe = 0
