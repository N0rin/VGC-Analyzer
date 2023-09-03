extends Node2D
class_name Pokemon

@export var species : Species
@export var ability : Ability
@export var item : Item
@export_enum( "Normal", "Grass", "Fire", "Water", "Electric", "Fighting", "Flying", 
"Poison", "Ground", "Rock", "Bug", "Ice", "Psychic", "Ghost", "Dragon", "Dark",
"Steel", "Fairy" ) var tera_type = "Normal"
@export_category("Effort Values")
@export_enum("None","Atk", "Def", "SpA", "SpD", "Spe") var increased_stat = "None"
@export_enum("None", "Atk", "Def", "SpA", "SpD", "Spe") var reduced_stat = "None"
@export var hp_evs = 0
@export var atk_evs = 0
@export var def_evs = 0
@export var spa_evs = 0
@export var spd_evs = 0
@export var spe_evs = 0
@export_category("Individual Values")
@export var hp_ivs = 31
@export var atk_ivs = 31
@export var def_ivs = 31
@export var spa_ivs = 31
@export var spd_ivs = 31
@export var spe_ivs = 31
@export_category("Moves")
@export var move1 : Move
@export var move2 : Move
@export var move3 : Move
@export var move4 : Move

var health = 100
var condition = ""
var terracrystalized = false
var combat_data = ""
