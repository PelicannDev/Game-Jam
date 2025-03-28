extends Node2D


func _on_battery_area_body_entered(body):
		if body.is_in_group("batteries"):
			body.locked = true
			$Lock.queue_free()


func _on_area_2d_body_entered(body):
	if body.name == "Player":
		$AudioStreamPlayer2D.play()
		body.visible = false
		await SceneTransition.transition_to("res://Scenes/title.tscn")
