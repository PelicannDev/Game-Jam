extends Area2D

@export var next_wire: NodePath
@export var is_start: bool = false
@export var teleport_offset: Vector2 = Vector2(0, -20)
@export var end_animation: String = "enterRight"  #this is you last animations name

var player_ref: CharacterBody2D = null
var is_animating: bool = false

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	$Wire.stop()

func _on_body_entered(body):
	if body.name == "Player":
		player_ref = body
		if $QKey:
			$QKey.visible = true

func _on_body_exited(body):
	if body.name == "Player":
		if $QKey:
			$QKey.visible = false
		player_ref = null

func _input(event):
	if not is_start or not player_ref or is_animating:
		return
	
	if event.is_action_pressed("interact"):
		print("Q pressed on wire: ", name)
		$QKey.queue_free()
		start_teleport()

func start_teleport():
	print("Starting teleport on: ", name)
	is_animating = true
	player_ref.visible = false
	player_ref.set_process(false)
	
	#first wire uses enterLeft
	$Wire.play("enterLeft")
	await $Wire.animation_finished
	
	if has_next_wire():
		var next = get_node(next_wire)
		if next.has_method("continue_teleport"):
			print("Passing to next wire: ", next.name)
			next.continue_teleport(player_ref)
	else:
		finish_teleport()

func continue_teleport(player):
	player_ref = player
	is_animating = true
	
	#determine anim to play
	if not has_next_wire():  #last wire
		print("Playing end animation (", end_animation, ") on: ", name)
		$Wire.play(end_animation)  #use the exported end_animation name
	else:
		print("Playing activate animation on: ", name)
		$Wire.play("activate")
	
	await $Wire.animation_finished
	
	if has_next_wire():
		var next = get_node(next_wire)
		if next.has_method("continue_teleport"):
			next.continue_teleport(player_ref)
	else:
		finish_teleport()

func finish_teleport():
	print("Finishing teleport on: ", name)
	if player_ref:
		player_ref.global_position = global_position + teleport_offset
		player_ref.visible = true
		player_ref.set_process(true)
		print("Player teleported to: ", player_ref.global_position)
	
	player_ref = null
	is_animating = false

#check for next wire
func has_next_wire() -> bool:
	return next_wire != NodePath("") and get_node_or_null(next_wire) != null
