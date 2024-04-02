extends Resource
class_name Modifier

enum STEP{BasePower, Attack, Defense, General, Final}
enum CAT{Extra, Weather, Terrain, StatStage, Screen, Persistent}

var name:String
var value:int = 4096
var apply_on: int
var category: int

func _init(init_name:String, init_value:int, init_apply:int, init_category:int):
	name = init_name
	value = init_value
	apply_on = init_apply
	category = init_category
	
