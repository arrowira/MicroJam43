extends Node2D

var G: Node

func _ready() -> void:
	G = get_node("/root/Global")
	get_node("Best").text = "Best min speed: " + str(int(G.minNum))
	get_node("Ranking").text = getRankingName(G.minNum)
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	if G.minNum < 1:
		tooSad()
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


func tooSad():
	get_node("NameEntry").visible = false
	get_node("NameEntrySave").visible = false


func offerToSaveScore():
	var existingName = G.playerName;
	get_node("NameEntry").text = existingName
	if existingName:
		postScore.call_deferred()
		# then user presses restart
	else:
		get_node("NameEntry").grab_focus.call_deferred()
		# then user enters name and presses-enter-or-clicks-save


func postScore():
	print("post score")
	await Leaderboards.post_guest_score(G.leaderboard_id, float(int(G.minNum)), G.playerName, {})
	#await get_node("LeaderboardUI").refresh_scores()

func _on_restart_pressed() -> void:
	get_tree().change_scene_to_file("res://main.tscn")


func _on_name_entry_text_submitted(_new_text: String) -> void:
	_on_name_entry_save_pressed()


func _on_name_entry_save_pressed() -> void:
	G.playerName = get_node("NameEntry").text
	postScore()
