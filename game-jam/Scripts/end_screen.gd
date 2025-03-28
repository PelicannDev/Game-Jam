extends Node2D

func _process(float):
	if Input.is_action_just_pressed("reset"):
		await SceneTransition.transition_to("res://Scenes/title.tscn")
