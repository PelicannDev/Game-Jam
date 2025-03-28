extends Node2D
func _ready():
	$AudioStreamPlayer2.play()
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.visible = false
		await SceneTransition.transition_to("res://Scenes/level_1.tscn")

func _on_battery_area_body_entered(body):
	if body.is_in_group("batteries"):
		body.locked = true
		$Light.play()
		$Lock.queue_free()
		$AudioStreamPlayer.play()
		$AudioStreamPlayer2.stop()
		Song.song()
		
