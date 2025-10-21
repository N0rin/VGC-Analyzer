extends Control
class_name PokemonButton
signal id_pressed(int)

@export var id = 0

func set_pokemon(pokemon:Species):
	$PokemonIcon.set_sprite(pokemon.texture_x, pokemon.texture_y, pokemon.texture_id)

func clear():
	$PokemonIcon.clear()
	$Button.button_pressed = false


func _on_button_pressed() -> void:
	emit_signal("id_pressed", id)
