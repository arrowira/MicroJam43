extends Node3D
var mouse_sensitivity = 0.002
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
func _process(delta: float) -> void:
	position = get_parent().get_node("CharacterBody3D").position
func _input(event):
	if event is InputEventMouseMotion:
		rotation.y -= event.relative.x*mouse_sensitivity
		
