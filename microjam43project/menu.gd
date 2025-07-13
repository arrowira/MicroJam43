extends Node2D


func getMin() -> float:
	return get_node("/root/Global").minNum
	
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

func _ready() -> void:
	get_node("Best").text = "Best min speed: " + str(int(getMin()))
	get_node("Ranking").text = getRankingName(getMin())
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	get_node("NameEntry").grab_focus.call_deferred()

	print("post score")
	await Leaderboards.post_guest_score('microjam43-highestminmph-F4E8', float(int(getMin())), "auto", {})


func _on_restart_pressed() -> void:
	get_tree().change_scene_to_file("res://main.tscn")
