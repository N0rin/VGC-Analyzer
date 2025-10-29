extends Resource
class_name AttackContext

@export var attacker: Pokemon
@export var defender: Pokemon
@export var used_attack = 1
@export var damage_roll = 0
@export var critical_hit = false
@export var terrain = ""
@export var weather = ""
@export var screen = ""
@export var ruin_sword = false
@export var ruin_beads = false
@export var ruin_tablets = false
@export var ruin_vessel = false
@export var paraboost = ""
@export var helping_hand = false
@export var friend_guard = false
@export var is_spread = false

func get_move() -> Move:
	if attacker.data.get_move(used_attack).name == "Weather Ball":
		var move_variant: Move = attacker.data.get_move(used_attack).duplicate()
		match(weather):
			"Sun":
				move_variant.type = "Fire"
				move_variant.base_damage = 100
			"Rain":
				move_variant.type = "Water"
				move_variant.base_damage = 100
			"Sand":
				move_variant.type = "Rock"
				move_variant.base_damage = 100
			"Snow":
				move_variant.type = "Ice"
				move_variant.base_damage = 100
		return move_variant
	
	return attacker.data.get_move(used_attack)
