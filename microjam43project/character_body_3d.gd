extends CharacterBody3D


var SPEED = 0.3
var turnSpeed = 0.03
var forward_dir = Vector3.ZERO
func _ready() -> void:
	get_parent().get_node("CanvasLayer").get_node("Control").get_node("MinMPHNumber").text = str(-6)
var minNum = -6.0
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	var input_forward = Input.get_action_strength("forward") - Input.get_action_strength("backward")
	var input_steer = Input.get_action_strength("right") - Input.get_action_strength("left")
	# friction
	minNum+=1/60.0
	get_parent().get_node("CanvasLayer").get_node("Control").get_node("MPHNumber").text = str(int(velocity.length()))
	get_parent().get_node("CanvasLayer").get_node("Control").get_node("MinMPHNumber").text = str(int(minNum))
	# Apply forward/reverse force
	var forward_dir = -transform.basis.z.normalized()
	if input_forward != 0:
		velocity += input_forward*forward_dir*SPEED
		velocity = velocity.lerp(Vector3.ZERO, delta * 1.1)
	else:
		velocity = velocity.lerp(Vector3.ZERO, delta * 2)
	
	
	
		
	# Apply steering (rotate the whole body)
	if velocity.length() > 0.1:
		var turn_amount = input_steer * 0.05 * delta
		if abs(velocity.length())<30:
			rotate_y(-turn_amount*velocity.length())
		else:
			rotate_y(-turn_amount*30)
		
	move_and_slide()

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == "powerUpBodyR":
		body.get_parent().queue_free()
		velocity = velocity*2
		SPEED+=0.1
		
