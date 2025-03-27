extends CharacterBody2D
	#Right Bound: 224 
	#Left Bound: -48 
	#Up Bound: -32 
	#Down Bound: 160

#player speed
var speed = 100
var can_move = true

func _physics_process(delta):
#setup direction of movement
	var direction = Input.get_vector("left", "right", "up", "down")

#stop diagonal movement by listening for input then setting axis to zero
	if can_move:
		if Input.is_action_pressed("right"):
			direction.y = 0
			get_node("AnimatedSprite2D").play("Right")

		elif Input.is_action_pressed("left"):
			direction.y = 0
			get_node("AnimatedSprite2D").play("Left")

		elif Input.is_action_pressed("up"):
			direction.x = 0
			get_node("AnimatedSprite2D").play("Up")

		elif Input.is_action_pressed("down"):
			direction.x = 0
			get_node("AnimatedSprite2D").play("Down")

		else:
			direction = Vector2.ZERO

#normalize the directional movement
	direction = direction.normalized()

#implement the actual movement
	if can_move:
		velocity = (direction * speed)
		move_and_slide()
	
	#clamp position
	position.x = clamp(position.x, 16, 304)
	position.y = clamp(position.y, 16, 224)
