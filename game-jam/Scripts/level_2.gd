extends Node2D

func _on_battery_area_body_entered(body):
		if body.is_in_group("batteries"):
			body.locked = true
			$Lock.queue_free()
			$Fan.play()
			$Fan2.play()
			$Fan3.play()
			$Fan4.play()
			$Light.play()
			$Light2.play()

func _on_area_2d_body_entered(body):
	if body.name == "Player":
		body.visible = false
		await SceneTransition.transition_to("res://Scenes/level3.tscn")
