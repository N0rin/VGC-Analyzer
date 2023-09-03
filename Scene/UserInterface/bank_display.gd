extends Control

func set_slot(pokemon:Pokemon) -> void:
	if pokemon == null:
		clear()
		return
	
	$TextureRect.texture = pokemon.species.sprite
	$ProgressBar.value = pokemon.health
	$ProgressBar.show()
	set_status(pokemon.condition)

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
	$ProgressBar.hide()
