extends Resource
class_name Move

@export var name: String
@export var base_damage = 0
@export var accuracy = 100
@export var priority =  0
@export_enum("Single","Enemies","Allies","All","Self","Partner") var targeting = "Single"
@export_enum("Physical", "Special", "Status") var category = "Physical"
@export_enum( "Normal", "Grass", "Fire", "Water", "Electric", "Fighting", "Flying", 
"Poison", "Ground", "Rock", "Bug", "Ice", "Psychic", "Ghost", "Dragon", "Dark",
"Steel", "Fairy" ) var type = "Normal"
@export var makes_contact = false
@export_group("Extra Effects")
@export var added_effect = ""
@export_range(0, 100, 1) var added_effect_chance = 0
@export var crit_bonus = 0
@export_group("Groups")
