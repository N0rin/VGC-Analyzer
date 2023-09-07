extends Control

@onready var field_effect_scene = load("res://Scene/field_info.tscn")
@onready var state_name = ""
@onready var state_turn = 0

func set_fighter(pokemon:Pokemon, slot:int) -> void:
	match(slot):
		0:
			$"Border/Mon-Field Split/VBoxContainer/MonGrid/FighterDisplay".set_fighter(pokemon)
		1:
			$"Border/Mon-Field Split/VBoxContainer/MonGrid/FighterDisplay2".set_fighter(pokemon)
		2:
			$"Border/Mon-Field Split/VBoxContainer/MonGrid/FighterDisplay3".set_fighter(pokemon)
		3:
			$"Border/Mon-Field Split/VBoxContainer/MonGrid/FighterDisplay4".set_fighter(pokemon)

func set_fighters(upper_left:Pokemon, upper_right:Pokemon, lower_left:Pokemon, lower_right:Pokemon) -> void:
	set_fighter(upper_left, 0)
	set_fighter(upper_right, 1)
	set_fighter(lower_left, 2)
	set_fighter(lower_right, 3)

func set_bank_slot(pokemon:Pokemon, slot:int, is_upper:bool) -> void:
	var display_slots : Array
	if is_upper:
		display_slots = $"Border/Mon-Field Split/VBoxContainer/UpperBank".get_children()
	else:
		display_slots = $"Border/Mon-Field Split/VBoxContainer/LowerBank".get_children()
	
	display_slots[slot].set_slot(pokemon)  

func set_bank(team:Array[Pokemon], is_upper:bool) -> void:
	var display_slots : Array
	if is_upper:
		display_slots = $"Border/Mon-Field Split/VBoxContainer/UpperBank".get_children()
	else:
		display_slots = $"Border/Mon-Field Split/VBoxContainer/LowerBank".get_children()  
	
	for slot in range(team.size()):
		display_slots[slot].set_slot(team[slot])

func add_field_effect(name:String, duration:int, position:int) -> void:
	var new_field = field_effect_scene.instantiate()
	new_field.set_values(name, duration)
	match(position):
		0:
			$"Border/Mon-Field Split/FieldEffects/UpperSide".add_child(new_field)
		1:
			$"Border/Mon-Field Split/FieldEffects/BothSides".add_child(new_field)
		2:
			$"Border/Mon-Field Split/FieldEffects/LowerSide".add_child(new_field)

func iterate_field():
	for effect in $"Border/Mon-Field Split/FieldEffects/UpperSide".get_children():
		effect.iterate()
		if effect.effect_duration == 0:
			$"Border/Mon-Field Split/FieldEffects/BothSides".remove_child(effect)
			effect.queue_free()
	for effect in $"Border/Mon-Field Split/FieldEffects/BothSides".get_children():
		effect.iterate()
		if effect.effect_duration == 0:
			$"Border/Mon-Field Split/FieldEffects/BothSides".remove_child(effect)
			effect.queue_free()
	for effect in $"Border/Mon-Field Split/FieldEffects/LowerSide".get_children():
		effect.iterate()
		if effect.effect_duration == 0:
			$"Border/Mon-Field Split/FieldEffects/BothSides".remove_child(effect)
			effect.queue_free()

func clear_field_effects():
	for effect in $"Border/Mon-Field Split/FieldEffects/UpperSide".get_children():
		$"Border/Mon-Field Split/FieldEffects/BothSides".remove_child(effect)
		effect.queue_free()
	for effect in $"Border/Mon-Field Split/FieldEffects/BothSides".get_children():
		$"Border/Mon-Field Split/FieldEffects/BothSides".remove_child(effect)
		effect.queue_free()
	for effect in $"Border/Mon-Field Split/FieldEffects/LowerSide".get_children():
		$"Border/Mon-Field Split/FieldEffects/BothSides".remove_child(effect)
		effect.queue_free()
