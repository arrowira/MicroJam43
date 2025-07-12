extends Node3D
var mouse_sensitivity = 0.001

func _process(delta: float) -> void:
	position = get_parent().get_node("CharacterBody3D").position
