extends Node2D

var unlock = 0

func _on_battery_area_body_entered(body):
	if body.is_in_group("batteries"):
		body.locked = true
		unlock += 1
		
		if unlock == 2:
			$Lock.queue_free()
			$Fan.play()
			$Fan2.play()
			$Lights.play()

func _on_area_2d_body_entered(body):
	if body.name == "Player":
		body.visible = false
		await SceneTransition.transition_to("res://Scenes/level_2.tscn")
