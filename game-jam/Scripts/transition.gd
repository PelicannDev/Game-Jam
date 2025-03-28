extends CanvasLayer

signal transition_complete

#reference to nodes
@onready var animation_player: AnimationPlayer = $TransitionPanel/Animator

func _ready():
	#start hidden
	visible = false
	$TransitionPanel.modulate.a = 0.0

func transition_to(scene_path: String):
	#visible then fade in
	visible = true
	animation_player.play("fade_out")
	await animation_player.animation_finished
	
	#scene change
	get_tree().change_scene_to_file(scene_path)
	
	#brief delay to allow scene to load
	await get_tree().process_frame
	
	#fade out
	animation_player.play("fade_in")
	await animation_player.animation_finished
	
	visible = false
	emit_signal("transition_complete")
