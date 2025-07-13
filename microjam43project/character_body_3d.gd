extends CharacterBody3D


var SPEED = 0.3
var turnSpeed = 0.03
var forward_dir = Vector3.ZERO
var ended = false
var inRainbow = false
static var brokenCar := preload("res://broken_car.tscn")

func _ready() -> void:
	get_parent().get_node("CanvasLayer").get_node("Control").get_node("MinMPHNumber").text = str(-6)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
var minNum = -6.0
func _physics_process(delta: float) -> void:
	#track place frenquency
	if !ended:
		$carModel/trackPlacer.amount_ratio=velocity.length()/16
		$carModel/trackPlacer2.amount_ratio=velocity.length()/16
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	var input_forward = Input.get_action_strength("forward") - Input.get_action_strength("backward")
	var input_steer = Input.get_action_strength("right") - Input.get_action_strength("left")
	# friction
	if !ended:
		minNum+=1/60.0
	get_parent().get_node("CanvasLayer").get_node("Control").get_node("MPHNumber").text = str(int(velocity.length()))
	get_parent().get_node("CanvasLayer").get_node("Control").get_node("MinMPHNumber").text = str(int(minNum))
	# Apply forward/reverse force
	var forward_dir2 = -transform.basis.z.normalized()
	if input_forward != 0 and !ended:
		velocity += input_forward*forward_dir2*SPEED
		velocity = velocity.lerp(Vector3.ZERO, delta * 1.1)
	else:
		velocity = velocity.lerp(Vector3.ZERO, delta * 2)
	
	if velocity.length()<minNum and !ended:
		#game over
		$carModel.queue_free()
		var deathModel = brokenCar.instantiate()
		deathModel.global_transform.origin = position
		
		ended = true
		add_child(deathModel)
		$explosionSFX.play()
		$CarDebris.emitting=true
		$Fire.emitting=true
		$Timer.start()
	
		
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
		$powerUpSfx.play()
	if body.name == "powerUpBodyG":
		body.get_parent().queue_free()
		SPEED += 0.1
		$powerUpSfx.play()
	if body.name == "powerUpBodyB":
		body.get_parent().queue_free()
		velocity = velocity*0.7
		SPEED += 0.2
		$powerUpSfx.play()
	if body.name == "rainbow" and !inRainbow:
		print("inRainbow")
		inRainbow = true
		$AudioStreamPlayer.play()
		$RainbowTimer.start()
		get_parent().get_node("RainbowCanvas/RainbowScreen2").visible = true
		get_parent().get_node("RainbowCanvas/RainbowScreen").visible = true
		velocity = velocity*3
		SPEED+=1
		


func _on_button_pressed() -> void:
	get_tree().reload_current_scene()



func goto_menu(score):
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_parent().get_node("CanvasLayer/DeathScreen").visible = true

	print("post score")
	await Leaderboards.post_guest_score('microjam43-highestminmph-F4E8', score, "auto", {})

	if minNum<10:
		
		get_parent().get_node("CanvasLayer/DeathScreen/Label3").text = "copper"
	elif minNum<30:
		get_parent().get_node("CanvasLayer/DeathScreen/Label3").text = "bronze"
	elif minNum<50:
		get_parent().get_node("CanvasLayer/DeathScreen/Label3").text = "silver"
	elif minNum<70:
		get_parent().get_node("CanvasLayer/DeathScreen/Label3").text = "gold"
	elif minNum<90:
		get_parent().get_node("CanvasLayer/DeathScreen/Label3").text = "platinum"
	elif minNum<110:
		get_parent().get_node("CanvasLayer/DeathScreen/label3").text = "emerald"
	elif minNum<150:
		get_parent().get_node("CanvasLayer/DeathScreen/label3").text = "diamond"
	else:
		get_parent().get_node("CanvasLayer/DeathScreen/label3").text = "Jack Traven"


func _on_timer_timeout() -> void:
	if not get_parent().get_node("CanvasLayer/DeathScreen").visible:
		goto_menu(int(minNum))

func _on_rainbow_timer_timeout() -> void:
	SPEED-=1
	inRainbow=false
	get_parent().get_node("RainbowCanvas/RainbowScreen2").visible = false
	get_parent().get_node("RainbowCanvas/RainbowScreen").visible = false
	print("exit")
