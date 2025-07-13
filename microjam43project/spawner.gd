extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
var worldSize = 1000
static var blue := preload("res://power_up_blue.tscn")
static var red := preload("res://power_up_red.tscn")
static var green := preload("res://power_up_green.tscn")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
var t = 0
func _physics_process(delta: float) -> void:
	t+=1/60.0
	if int(t)%2 == 0:
		t+=1
		
		for i in range(1):
			var greenPup := green.instantiate()
			var redPup := red.instantiate()
			var bluePup := blue.instantiate()
			greenPup.global_transform.origin = Vector3(randf_range(-worldSize / 2., worldSize/ 2.),-5,randf_range(-worldSize / 2., worldSize / 2.))
			redPup.global_transform.origin = Vector3(randf_range(-worldSize / 2., worldSize/ 2.),-5,randf_range(-worldSize / 2., worldSize / 2.))
			bluePup.global_transform.origin = Vector3(randf_range(-worldSize / 2., worldSize/ 2.),-5,randf_range(-worldSize / 2., worldSize / 2.))
			
			add_child(redPup)
			add_child(bluePup)
			add_child(greenPup)
