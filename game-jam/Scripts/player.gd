extends CharacterBody2D

# Movement bounds (unchanged)
# Right Bound: 224 
# Left Bound: -48 
# Up Bound: -32 
# Down Bound: 160

# Player speed
var speed = 100
var can_move = true
var last_direction = Vector2.DOWN  # Default facing down at start

# Input buffer system
var input_buffer = []
var input_buffer_readout = Vector2.ZERO

func _physics_process(delta):
	# Handle input buffer
	if Input.is_action_just_pressed("right"):
		input_buffer.append(Vector2.RIGHT)
	elif Input.is_action_just_pressed("left"):
		input_buffer.append(Vector2.LEFT)
	elif Input.is_action_just_pressed("up"):
		input_buffer.append(Vector2.UP)
	elif Input.is_action_just_pressed("down"):
		input_buffer.append(Vector2.DOWN)

	# Remove released directions
	if Input.is_action_just_released("right"):
		input_buffer.erase(Vector2.RIGHT)
	elif Input.is_action_just_released("left"):
		input_buffer.erase(Vector2.LEFT)
	elif Input.is_action_just_released("up"):
		input_buffer.erase(Vector2.UP)
	elif Input.is_action_just_released("down"):
		input_buffer.erase(Vector2.DOWN)

	# Get latest input
	if input_buffer.size() > 0:
		input_buffer_readout = input_buffer[-1]
		last_direction = input_buffer_readout  # Update last direction when moving
	else:
		input_buffer_readout = Vector2.ZERO

	# Animation handling
	if can_move:
		if input_buffer_readout != Vector2.ZERO:
			# Moving animations
			if input_buffer_readout == Vector2.RIGHT:
				$AnimatedSprite2D.play("Right")
			elif input_buffer_readout == Vector2.LEFT:
				$AnimatedSprite2D.play("Left")
			elif input_buffer_readout == Vector2.UP:
				$AnimatedSprite2D.play("Up")
			elif input_buffer_readout == Vector2.DOWN:
				$AnimatedSprite2D.play("Down")
		else:
			# Idle animations (based on last_direction)
			if last_direction == Vector2.RIGHT:
				$AnimatedSprite2D.play("IdleRight")
			elif last_direction == Vector2.LEFT:
				$AnimatedSprite2D.play("IdleLeft")
			elif last_direction == Vector2.UP:
				$AnimatedSprite2D.play("IdleUp")
			elif last_direction == Vector2.DOWN:
				$AnimatedSprite2D.play("IdleDown")

	# Movement
	if can_move:
		velocity = input_buffer_readout * speed
		move_and_slide()

	# Reset scene
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
