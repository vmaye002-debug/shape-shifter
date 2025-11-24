extends RigidBody2D

enum { SPAWN, JUMP }
var state = SPAWN

@export var health: int = 5
@export var phase_time: float = 6.0
@export var spawn_rate: float = 2.0 # Slower by default

@export_category("Spawning Setup")
@export var warning_scene: PackedScene # Drag your warning.tscn here
@export var triangle_area: ReferenceRect
@export var square_area: ReferenceRect

# Preloaded Enemies
var tri_scene = preload("res://enemy_triangle.tscn")
var sq_scene = preload("res://enemy_square.tscn")
var circle_scene = preload("res://Circle Enemy/circle_enemy.tscn")

var spawn_timer: Timer

func _ready() -> void:
	contact_monitor = true
	max_contacts_reported = 4
	body_entered.connect(_on_collision)
	

	var phase = Timer.new()
	phase.wait_time = phase_time
	phase.autostart = true
	phase.timeout.connect(_swap_states)
	add_child(phase)

	# Spawn Timer
	spawn_timer = Timer.new()
	spawn_timer.wait_time = spawn_rate
	spawn_timer.autostart = true
	spawn_timer.timeout.connect(_attempt_spawn)
	add_child(spawn_timer)

func _integrate_forces(s: PhysicsDirectBodyState2D) -> void:
	if state == SPAWN:
		s.linear_velocity = s.linear_velocity.lerp(Vector2.ZERO, 0.1)
		s.angular_velocity = lerp(s.angular_velocity, 0.0, 0.1)

func _swap_states() -> void:
	state = JUMP if state == SPAWN else SPAWN
	
	if state == SPAWN:
		spawn_timer.start()
	else:
		spawn_timer.stop()
		apply_impulse(Vector2.UP * 800)

func _on_collision(_body) -> void:
	if state == JUMP:
		if randf() < 0.25:
			_roll_towards_player()
		else:
			var dir = Vector2(randf_range(-1, 1), -0.5).normalized()
			apply_impulse(dir * 800)

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
