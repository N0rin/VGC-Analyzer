extends Control

func _on_button_analyzer_pressed():
	$Main.hide()
	$Analyzer.show()

func _on_button_calculations_pressed():
	$Main.hide()
	$Calculations.show()

func _on_button_metasets_pressed():
	$Main.hide()
	$Metasets.show()

func _on_button_quit_pressed():
	get_tree().quit()

func _on_signal_back_to_main():
	$Analyzer.hide()
	$Calculations.hide()
	$Metasets.hide()
	$Main.show()

func _on_analyzer_continue_to_board() -> void:
	$Analyzer.hide()
	$AnalyzeBoard.show()

func _on_calculations_to_meta() -> void:
	$Calculations/MetaCalcs.startup()

func _on_calculations_to_overview() -> void:
	$Calculations/CalcOverview.startup()

func _on_calculations_to_team_overview() -> void:
	$Calculations/TeamOverview.startup()

func _on_metasets_create_set() -> void:
	$Metasets/PokemonSetCreator.startup()

func _on_metasets_create_team() -> void:
	$Metasets/PokemonTeamCreator.startup()

func _on_calculations_to_matchup() -> void:
	$Calculations/MatchupCalcs.startup()
