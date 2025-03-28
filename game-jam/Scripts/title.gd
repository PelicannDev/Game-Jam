extends Node2D
func _ready():
	$AudioStreamPlayer2.play()
func _on_area_2d_body_entered(body):
	$AudioStreamPlayer2.stop()
	$Player.visible = false
	$Plug.play()
	$AudioStreamPlayer.play()

func _on_plug_animation_finished():
	await SceneTransition.transition_to("res://Scenes/level_0.tscn")
