extends RigidBody2D

var grid_size = 16
var target_position: Vector2 = Vector2.ZERO  #lerp target
var move_speed = 5.0  #speed of movement
var is_moving = false  #if battery is currently moving
var can_move = true #checks if the battery can move (done lerping)
var player = null

func _ready():
	#get player node
	player = get_parent().get_node("Player")
	if player == null:
		print("Error: Player node not found!")
	else:
		print("Player node found successfully!")

	#set gravity to 0
	gravity_scale = 0

func _input(event):
	if event.is_action_pressed("battery") and can_move:
		determine_direction()
		is_moving = true  #start lerp
		can_move = false  #player cant move
		print("Battery target position set to:", target_position)

		#disable player movement by setting its can_move to false
		if player:
			player.can_move = false
			print("Player movement disabled.")

#determine direction of movement based on Area2D overlap
func determine_direction():
	if $Sprite/UpArea2D.get_overlapping_bodies().has(player):
		target_position = position + Vector2(0, grid_size)  #up

	elif $Sprite/DownArea2D.get_overlapping_bodies().has(player):
		target_position = position + Vector2(0, -grid_size)  #down

	elif $Sprite/LeftArea2D.get_overlapping_bodies().has(player):
		target_position = position + Vector2(grid_size, 0)  #left

	elif $Sprite/RightArea2D.get_overlapping_bodies().has(player):
		target_position = position + Vector2(-grid_size, 0)  #right

	else:
		is_moving = false  #prevent movement if no direction is detected

	#snap to grid
	target_position = target_position.snapped(Vector2(grid_size, grid_size))

func _process(delta):
	if $Sprite/UpArea2D.get_overlapping_bodies().has(player): 
		$eKey2.visible = true
	elif $Sprite/DownArea2D.get_overlapping_bodies().has(player): 
		$eKey.visible = true
	elif $Sprite/LeftArea2D.get_overlapping_bodies().has(player):
		$eKey3.visible = true
	elif $Sprite/RightArea2D.get_overlapping_bodies().has(player):
		$eKey4.visible = true

	else:
		$eKey.visible = false
		$eKey2.visible = false
		$eKey3.visible = false
		$eKey4.visible = false
	
	if is_moving:
		position = position.lerp(target_position, move_speed * delta)  #lerp
		print("Battery position during lerp:", position)

		if position.distance_to(target_position) < 0.1:  #check if done
			position = target_position  #snap
			is_moving = false  #lerp is done
			can_move = true  #battery can_move var
			print("Battery movement complete, ready to move again")

			#player movement by setting its can_move to true
			if player:
				player.can_move = true
