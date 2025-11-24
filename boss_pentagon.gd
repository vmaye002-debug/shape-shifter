extends RigidBody2D

@export var health: int = 5
@export var spawn_rate: float = 2.0
@export var jump_force: float = 800.0

@export_category("Spawning Setup")
@export var warning_scene: PackedScene
@export var triangle_area: ReferenceRect
@export var square_area: ReferenceRect

var tri_scene = preload("res://enemy_triangle.tscn")
var sq_scene = preload("res://enemy_square.tscn")
var circle_scene = preload("res://Circle Enemy/circle_enemy.tscn")

# NEW: Track invulnerability state
var is_invulnerable: bool = false

func _ready() -> void:
	contact_monitor = true
	max_contacts_reported = 4
	body_entered.connect(_on_collision)
	
	var timer = Timer.new()
	timer.wait_time = spawn_rate
	timer.autostart = true
	timer.timeout.connect(_attempt_spawn)
	add_child(timer)
	
	apply_impulse(Vector2.UP * jump_force)

func _on_collision(body: Node) -> void:
	if body.is_in_group("Player"):
		# If we are currently invulnerable, ignore the hit
		if is_invulnerable:
			return

		# REMOVED: The height check (global_position.y < global_position.y - 10)
		# ADDED: Damage logic for any collision form
		health -= 1
		
		# ADDED: Fling the boss away from the player
		var direction_away = (global_position - body.global_position).normalized()
		# Apply a strong impulse in that direction. 
		# We add a slight upward force (-0.2 Y) to ensure it arcs through the air 
		# rather than sliding on the ground.
		apply_impulse((direction_away + Vector2(0, -0.2)).normalized() * 1500)
		
		if health <= 0:
			queue_free()
		else:
			# ADDED: Start Invulnerability Timer
			_start_invulnerability()
			
		return # Stop processing the rest of the function (movement logic)

	# Normal movement logic for when hitting walls/floor
	if randf() < 0.25:
		_roll_towards_player()
	else:
		var dir = Vector2(randf_range(-1, 1), -0.5).normalized()
		apply_impulse(dir * jump_force)

# NEW: Handle invulnerability cooldown and visuals
func _start_invulnerability() -> void:
	is_invulnerable = true
	modulate.a = 0.5 # Visual feedback: Make boss semi-transparent
	
	await get_tree().create_timer(1.0).timeout
	
	modulate.a = 1.0 # Reset transparency
	is_invulnerable = false

func _roll_towards_player() -> void:
	var player = get_tree().get_first_node_in_group("Player")
	if player:
		var dir = (player.global_position - global_position).normalized()
		apply_impulse(Vector2(dir.x * 1000, -200)) 
		apply_torque_impulse(20000 * sign(dir.x))

func _attempt_spawn() -> void:
	if randf() < 0.10:
		var circ = circle_scene.instantiate()
		circ.global_position = global_position
		get_parent().add_child(circ)
	else:
		_spawn_normal_enemy()

func _spawn_normal_enemy() -> void:
	if randf() > 0.5:
		var pos = square_area.global_position + Vector2(randf() * square_area.size.x, randf() * square_area.size.y)
		_spawn_with_warning(sq_scene, pos)
	else:
		var t_x = triangle_area.global_position.x + (randf() * triangle_area.size.x)
		var start = Vector2(t_x, triangle_area.global_position.y)
		var hit = get_world_2d().direct_space_state.intersect_ray(
			PhysicsRayQueryParameters2D.create(start, start + Vector2(0, 2000), 1, [self])
		)
		if hit:
			_spawn_with_warning(tri_scene, hit.position - Vector2(0, 10))

func _spawn_with_warning(enemy_scene, target_pos) -> void:
	if warning_scene:
		var warn = warning_scene.instantiate()
		warn.global_position = target_pos
		get_parent().add_child(warn)
	
	await get_tree().create_timer(0.8).timeout
	
	var enemy = enemy_scene.instantiate()
	enemy.global_position = target_pos
	get_parent().add_child(enemy)
