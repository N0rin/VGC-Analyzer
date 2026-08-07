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

func _on_analyzer_continue_to_board(team1, team2) -> void:
	$Analyzer/NewAnalysis.hide()
	$Analyzer/AnalysisBoard.battle_data.upper_team = team1.team_members
	$Analyzer/AnalysisBoard.battle_data.lower_team = team2.team_members
	$Analyzer/AnalysisBoard.initialize_board()
	$Analyzer/AnalysisBoard.set_edit_names()
	$Analyzer/AnalysisBoard.show()
	

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


func _on_analyzer_to_load_analysis() -> void:
	$Analyzer/LoadAnalysis.startup()


func _on_analyzer_to_new_analysis() -> void:
	$Analyzer/NewAnalysis.startup()


func _on_load_analysis_load_battle_data(battle_data: GameData) -> void:
	$Analyzer/LoadAnalysis.hide()
	$Analyzer/AnalysisBoard.battle_data = battle_data
	#$Analyzer/AnalysisBoard.load_gamestate([])
	$Analyzer/AnalysisBoard.show()
