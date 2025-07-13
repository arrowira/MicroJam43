@tool
extends Node

@export var enabled: bool = true
@export var radius: float = 50
@export var speed: float = 1.5
@export var rot_off: float = 0

func _ready() -> void:
	pass # Replace with function body.


var t=0.
func _process(delta: float) -> void:
	if not Engine.is_editor_hint() or not enabled:
		return
	var car = get_parent().get_node("CharacterBody3D")
	t+= delta
	var v = t * speed
	car.velocity = Vector3(sin(v),0,cos(v))*radius
	car.rotation = Vector3(0,v+rot_off,0)
	car.move_and_slide()
