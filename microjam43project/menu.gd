extends Node2D

var G: Node

func _ready() -> void:
	G = get_node("/root/Global")
	get_node("Best").text = "Min speed: " + str(int(G.minNum))
	get_node("Ranking").text = getRankingName(G.minNum)
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


	if G.minNum < 1:
		# score is too low to save
		hideNameField()
	else:
		offerToSaveScore()


func getRankingName(minNum):
	if minNum<10:
		return "copper"
	elif minNum<30:
		return "bronze"
	elif minNum<50:
		return "silver"
	elif minNum<70:
		return "gold"
	elif minNum<90:
		return "platinum"
	elif minNum<110:
		return "emerald"
	elif minNum<150:
		return "diamond"
	else:
		return "Jack Traven"


func hideNameField():
	get_node("NameEntry").visible = false
	get_node("NameEntrySave").visible = false


func offerToSaveScore():
	var existingName = G.playerName;
	get_node("NameEntry").text = existingName
	if existingName:
		hideNameField()
		postScore.call_deferred()
		# then user presses restart
	else:
		get_node("NameEntry").grab_focus.call_deferred()
		# then user enters name and presses-enter-or-clicks-save


func postScore():
	print("post score")
	if G.scoreToSubmit == 0:
		return
	await Leaderboards.post_guest_score(G.leaderboard_id, G.scoreToSubmit, G.playerName, {})
	G.scoreToSubmit = 0
	reloadLeaderboard()


func reloadLeaderboard():
	# doesn't work- type error on 'root'
	#await get_node("LeaderboardUI").refresh_scores()

	get_tree().change_scene_to_file("res://menu.tscn")


func _on_restart_pressed() -> void:
	get_tree().change_scene_to_file("res://main.tscn")


func _on_name_entry_text_submitted(_new_text: String) -> void:
	_on_name_entry_save_pressed()


func _on_name_entry_save_pressed() -> void:
	G.playerName = get_node("NameEntry").text
	postScore()
