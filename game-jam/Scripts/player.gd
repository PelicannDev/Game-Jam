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

# Improved input handling
var current_input = Vector2.ZERO

func _physics_process(delta):
	# Get raw input first
	var raw_input = Vector2.ZERO
	raw_input.x = Input.get_axis("left", "right")
	raw_input.y = Input.get_axis("up", "down")
	
	# Update current input (prioritizes last pressed direction)
	if Input.is_action_just_pressed("right"):
		current_input.x = 1
	if Input.is_action_just_pressed("left"):
		current_input.x = -1
	if Input.is_action_just_pressed("up"):
		current_input.y = -1
	if Input.is_action_just_pressed("down"):
		current_input.y = 1
		
	# Clear input when actions are released
	if Input.is_action_just_released("right") and current_input.x > 0:
		current_input.x = 0
	if Input.is_action_just_released("left") and current_input.x < 0:
		current_input.x = 0
	if Input.is_action_just_released("up") and current_input.y < 0:
		current_input.y = 0
	if Input.is_action_just_released("down") and current_input.y > 0:
		current_input.y = 0
	
	# Fall back to raw input if no buffered input
	var final_input = current_input if current_input != Vector2.ZERO else raw_input
	
	# Update last direction if we're moving
	if final_input != Vector2.ZERO:
		last_direction = final_input.normalized()

	# Animation handling
	if can_move:
		if final_input != Vector2.ZERO:
			# Moving animations
			if final_input.x > 0:
				$AnimatedSprite2D.play("Right")
			elif final_input.x < 0:
				$AnimatedSprite2D.play("Left")
			elif final_input.y < 0:
				$AnimatedSprite2D.play("Up")
			elif final_input.y > 0:
				$AnimatedSprite2D.play("Down")
		else:
			# Idle animations (based on last_direction)
			if last_direction.x > 0:
				$AnimatedSprite2D.play("IdleRight")
			elif last_direction.x < 0:
				$AnimatedSprite2D.play("IdleLeft")
			elif last_direction.y < 0:
				$AnimatedSprite2D.play("IdleUp")
			elif last_direction.y > 0:
				$AnimatedSprite2D.play("IdleDown")

	# Movement
	if can_move:
		velocity = final_input.normalized() * speed
		move_and_slide()

	# Reset scene
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
