extends Resource
class_name AttackContext

var attacker: Pokemon
var defender: Pokemon
var used_attack = 1
var damage_roll = 0
var terrain = ""
var weather = ""
var screen = ""
var ruin_sword = false
var ruin_beads = false
var ruin_tablets = false
var ruin_vessel = false
var paraboost = ""
var helping_hand = false
var friend_guard = false

func get_move() -> Move:
	return attacker.data.get_move(used_attack)
