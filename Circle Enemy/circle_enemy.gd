extends RigidBody2D


@export var speed_spawn: Vector2 = Vector2(-20000.0,0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	apply_central_force(speed_spawn)

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.state_now == "S":
		queue_free()
	print(body)
	pass # Replace with function body.
