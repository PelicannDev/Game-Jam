extends CharacterBody2D

var currPos = [0,0]

func _input(event):
	#Right Bound: 224 
	#Left Bound: -48 
	#Up Bound: -32 
	#Down Bound: 160
	
	if event.is_action_pressed("right") && currPos[0] < 224:
		currPos[0] += 16
		get_node("Sprite2D").look_at(self.position + Vector2(1,0))
		
	elif event.is_action_pressed("left") && currPos[0] > -48:
		currPos[0] -= 16
		get_node("Sprite2D").look_at(self.position + Vector2(-1,0))
		
	elif event.is_action_pressed("up") && currPos[1] > -32:
		currPos[1] -= 16
		get_node("Sprite2D").look_at(self.position + Vector2(0,1))
			
	elif event.is_action_pressed("down") && currPos[1] < 160:
		currPos[1] += 16
		get_node("Sprite2D").look_at(self.position + Vector2(0,-1))
		
	self.position = Vector2(currPos[0], currPos[1])

func _process(delta: float) -> void:
	print(currPos[1])
