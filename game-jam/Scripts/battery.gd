extends RigidBody2D

# Movement Settings
@export var grid_size: int = 16
@export var move_speed: float = 5.0
var target_position: Vector2 = position
var is_moving: bool = false
var can_move: bool = true
var locked: bool = false

# Node References
@onready var up_area: Area2D = $Sprite/UpArea2D
@onready var down_area: Area2D = $Sprite/DownArea2D
@onready var left_area: Area2D = $Sprite/LeftArea2D
@onready var right_area: Area2D = $Sprite/RightArea2D
@onready var e_key: Sprite2D = $eKey
@onready var e_key2: Sprite2D = $eKey2
@onready var e_key3: Sprite2D = $eKey3
@onready var e_key4: Sprite2D = $eKey4
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

# Cached references
var player: CharacterBody2D = null
var tilemap: TileMap = null

# Offsets for precise collision
const UP_OFFSET = Vector2(0, 8)
const DOWN_OFFSET = Vector2(0, -8)
const LEFT_OFFSET = Vector2(8, 0)
const RIGHT_OFFSET = Vector2(-8, 0)

func _ready():
	add_to_group("batteries")
	target_position = position
	gravity_scale = 0
	find_references()
	
func find_references():
	# Find player
	player = get_tree().get_first_node_in_group("player")
	if !player:
		player = get_node_or_null("../Player")  # Fallback: Check parent directory
		if !player:
			push_warning("Player not found for battery ", name)
	
	# Find tilemap
	tilemap = get_tree().get_first_node_in_group("tilemap")
	if !tilemap:
		tilemap = get_node_or_null("../TileMap")  # Fallback: Check parent directory
		if !tilemap:
			push_warning("TileMap not found for battery ", name)

func _input(event):
	if locked or is_moving or !can_move:
		return
		
	if event.is_action_pressed("battery"):
		# Check if player is touching this specific battery
		var player_touching = (up_area.has_overlapping_bodies() and up_area.get_overlapping_bodies().has(player)) or \
							(down_area.has_overlapping_bodies() and down_area.get_overlapping_bodies().has(player)) or \
							(left_area.has_overlapping_bodies() and left_area.get_overlapping_bodies().has(player)) or \
							(right_area.has_overlapping_bodies() and right_area.get_overlapping_bodies().has(player))
		
		if player_touching and determine_direction() and is_path_clear():
			is_moving = true
			can_move = false
			$AudioStreamPlayer.play()
			if player:
				player.can_move = false

func is_path_clear() -> bool:
	if !tilemap or !player:
		return false
		
	var check_pos: Vector2
	
	# Determine check position based on player interaction
	if up_area.has_overlapping_bodies() and up_area.get_overlapping_bodies().has(player):
		check_pos = position + UP_OFFSET + Vector2(0, grid_size)
	elif down_area.has_overlapping_bodies() and down_area.get_overlapping_bodies().has(player):
		check_pos = position + DOWN_OFFSET + Vector2(0, -grid_size)
	elif left_area.has_overlapping_bodies() and left_area.get_overlapping_bodies().has(player):
		check_pos = position + LEFT_OFFSET + Vector2(grid_size, 0)
	elif right_area.has_overlapping_bodies() and right_area.get_overlapping_bodies().has(player):
		check_pos = position + RIGHT_OFFSET + Vector2(-grid_size, 0)
	else:
		return false
	
	# Check for tilemap obstacles
	var tile_pos = tilemap.local_to_map(check_pos)
	if tilemap.get_cell_source_id(0, tile_pos) == -1:
		return false
		
	var tile_data = tilemap.get_cell_tile_data(0, tile_pos)
	if tile_data and tile_data.get_collision_polygons_count(0) > 0:
		return false
	
	# Check for other batteries in the target position
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsShapeQueryParameters2D.new()
	query.collision_mask = collision_mask
	query.collide_with_bodies = true
	query.transform = Transform2D(0, check_pos)
	query.set_shape(collision_shape.shape)
	
	var results = space_state.intersect_shape(query, 1)
	for result in results:
		if result.collider != self and result.collider.is_in_group("batteries"):
			return false
	
	return true

func determine_direction() -> bool:
	if locked or !player:
		return false
		
	var can_move_battery = false
	
	if up_area.has_overlapping_bodies() and up_area.get_overlapping_bodies().has(player):
		target_position = position + Vector2(0, grid_size)
		can_move_battery = true
	elif down_area.has_overlapping_bodies() and down_area.get_overlapping_bodies().has(player):
		target_position = position + Vector2(0, -grid_size)
		can_move_battery = true
	elif left_area.has_overlapping_bodies() and left_area.get_overlapping_bodies().has(player):
		target_position = position + Vector2(grid_size, 0)
		can_move_battery = true
	elif right_area.has_overlapping_bodies() and right_area.get_overlapping_bodies().has(player):
		target_position = position + Vector2(-grid_size, 0)
		can_move_battery = true

	if can_move_battery:
		target_position = target_position.snapped(Vector2(grid_size, grid_size))
	return can_move_battery

func _process(delta):
	update_prompts()
	
	if is_moving:
		position = position.lerp(target_position, move_speed * delta)
		if position.distance_to(target_position) < 1.0:  # Slightly larger threshold
			finish_movement()

func update_prompts():
	if !player:
		e_key.visible = false
		e_key2.visible = false
		e_key3.visible = false
		e_key4.visible = false
		return
	
	var show_prompts = not locked and not is_moving and can_move
	
	e_key.visible = show_prompts and down_area.has_overlapping_bodies() and down_area.get_overlapping_bodies().has(player) and is_path_clear()
	e_key2.visible = show_prompts and up_area.has_overlapping_bodies() and up_area.get_overlapping_bodies().has(player) and is_path_clear()
	e_key3.visible = show_prompts and left_area.has_overlapping_bodies() and left_area.get_overlapping_bodies().has(player) and is_path_clear()
	e_key4.visible = show_prompts and right_area.has_overlapping_bodies() and right_area.get_overlapping_bodies().has(player) and is_path_clear()

func reset_battery():
	locked = false
	can_move = true
	is_moving = false
	target_position = position.snapped(Vector2(grid_size, grid_size))

func finish_movement():
	position = target_position
	is_moving = false
	can_move = true
	if player:
		player.can_move = true
