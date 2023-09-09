extends Control

func set_fighter(pokemon:Pokemon) -> void:
	if pokemon == null:
		clear()
		return
	
	$TextureRect.texture = pokemon.data.species.sprite
	$MarginContainer/ProgressBar.value = pokemon.state.health
	$"Slot Info/InfoText".text = pokemon.state.combat_data
	set_status(pokemon.state.condition)
	set_terra(pokemon.state.terracrystalized)

func set_status(status:String) -> void:
	$"Status Info/brn".hide()
	$"Status Info/frz".hide()
	$"Status Info/par".hide()
	$"Status Info/psn".hide()
	$"Status Info/slp".hide()
	$"Status Info/tox".hide()
	
	match(status):
		"brn":
			$"Status Info/brn".show()
		"frz":
			$"Status Info/frz".show()
		"par":
			$"Status Info/par".show()
		"psn":
			$"Status Info/psn".show()
		"slp":
			$"Status Info/slp".show()
		"tox":
			$"Status Info/tox".show()

func clear() -> void:
	$TextureRect.texture = null
	$MarginContainer/ProgressBar.value = 0
	$"Slot Info/InfoText".text = ""
	set_status("")
	$Terra.hide()

func set_terra(is_terra:bool):
	if is_terra:
		$Terra.show()
	else:
		$Terra.hide()
