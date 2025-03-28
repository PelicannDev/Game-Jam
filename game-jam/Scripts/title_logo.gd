extends Sprite2D

# Animation Settings
@export var bounce_height: float = 20.0       # Bounce height in pixels
@export var bounce_speed: float = 1.8      # Bounce animation speed
@export var wiggle_angle: float = 3.0        # Max rotation angle (degrees)
@export var wiggle_speed: float = 2.5        # Rotation speed
@export var scale_pulse_amount: float = 0.1  # Size pulse intensity

# Private Variables
var starting_y: float
var time_accumulated: float = 0.0

func _ready():
	# Configure crisp rendering
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	self_modulate.a = 1.0
	
	# Store initial position
	starting_y = position.y
	
	# Optional: Random starting position
	time_accumulated = randf_range(0, 2.0)

func _process(delta):
	time_accumulated += delta
	
	# 1. Bounce Animation (Pixel-Perfect)
	var bounce_offset = sin(time_accumulated * bounce_speed) * bounce_height
	position.y = floor(starting_y + bounce_offset)
	
	# 2. Gentle Wiggling Rotation (No Shader Needed)
	rotation_degrees = sin(time_accumulated * wiggle_speed) * wiggle_angle
	
	# 3. Scale Pulse
	var scale_pulse = 1.0 + sin(time_accumulated * bounce_speed * 1.5) * scale_pulse_amount
	scale = Vector2(scale_pulse, scale_pulse).snapped(Vector2(0.01, 0.01))
	
	# 4. Force pixel-perfect position
	position = position.snapped(Vector2.ONE)
