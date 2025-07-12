extends Node3D

static var tree := preload("res://ramp.tscn")

var worldSize = 1000
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(200):
		var treeSpawn = tree.instantiate()
		treeSpawn.global_transform.origin = Vector3(randf_range(-worldSize / 2, worldSize/ 2),0,randf_range(-worldSize / 2, worldSize / 2))
		treeSpawn.scale*=randf_range(0.5,2.0)
		add_child(treeSpawn)
