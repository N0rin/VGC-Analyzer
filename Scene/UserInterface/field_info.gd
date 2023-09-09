extends HBoxContainer
var effect_duration = 0

func set_values(name:String, duration:int) -> void:
	$Name.text = name
	effect_duration = duration
	if duration > 0:
		$Duration.text = str(duration)

func iterate():
	effect_duration -= 1;
	if effect_duration < 0:
		$Duration.hide()
	else:
		$Duration.text = str(effect_duration)
