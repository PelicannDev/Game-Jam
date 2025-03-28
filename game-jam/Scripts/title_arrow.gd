extends Sprite2D

#animation Settings
@export var bounce_height: float = 20.0       #bounce height in pixels
@export var bounce_speed: float = 1.8      #bounce animation speed
@export var wiggle_angle: float = 3.0        #max rotation angle (degrees)
@export var wiggle_speed: float = 2.5        #rotation speed
@export var scale_pulse_amount: float = 0.1  #size pulse intensity

#vars
var starting_y: float
var time_accumulated: float = 0.0

func _ready():
	#configure renderings
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	self_modulate.a = 1.0
	
	#store initial position
	starting_y = position.y
	
	#random starting position
	time_accumulated = randf_range(0, 2.0)

func _process(delta):
	time_accumulated += delta
	
	var bounce_offset = sin(time_accumulated * bounce_speed) * bounce_height
	position.y = floor(starting_y + bounce_offset)
	
	rotation_degrees = sin(time_accumulated * wiggle_speed) * wiggle_angle
	
	var scale_pulse = 1.0 + sin(time_accumulated * bounce_speed * 1.5) * scale_pulse_amount
	scale = Vector2(scale_pulse, scale_pulse).snapped(Vector2(0.01, 0.01))
	
	position = position.snapped(Vector2.ONE)
