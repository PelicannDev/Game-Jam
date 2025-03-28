extends Node2D

var unlock = 0

func _on_battery_area_body_entered(body):
		if body.is_in_group("batteries"):
			body.locked = true
			unlock += 1

func _process(delta):
	if unlock == 1:
		$Wall/CollisionShape2D.disabled = false
		$Wall.visible = true
	else:
		$Wall/CollisionShape2D.disabled = true
