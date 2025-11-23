extends CharacterBody2D


@export var areaDetect:Area2D
var startingY:float
var returning:bool = false

func _physics_process(delta: float) -> void:
	var collision = move_and_collide(velocity * delta)
	if collision:
		returning = true
		if collision.get_collider().name == "Player" and collision.get_collider().state_now == "T":
			queue_free()
			
	if returning:
		if position.y > startingY:
			velocity.y = -400
		else:
			velocity.y = 0
			position.y = startingY
			returning = false
		

	#move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	print(body)
	velocity.y = 600;
	pass # Replace with function body.


func _on_area_2d_ready() -> void:
	startingY = position.y
	pass # Replace with function body.
