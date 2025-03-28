extends CanvasLayer

signal transition_complete

# Reference to nodes - adjust these paths if your structure is different
@onready var animation_player: AnimationPlayer = $TransitionPanel/Animator

func _ready():
	# Start hidden
	visible = false
	$TransitionPanel.modulate.a = 0.0

func transition_to(scene_path: String):
	# Make visible and fade in
	visible = true
	animation_player.play("fade_out")
	await animation_player.animation_finished
	
	# Scene change
	get_tree().change_scene_to_file(scene_path)
	
	# Brief delay to allow new scene to load
	await get_tree().process_frame
	
	# Fade out
	animation_player.play("fade_in")
	await animation_player.animation_finished
	
	visible = false
	emit_signal("transition_complete")
