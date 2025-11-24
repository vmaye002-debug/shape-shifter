extends CharacterBody2D




func _physics_process(delta: float) -> void:
	var collision = move_and_collide(velocity * delta)
	if collision and collision.get_collider().name == "Player" and collision.get_collider().state_now == "C":
			queue_free()
