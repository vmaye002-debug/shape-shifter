extends CharacterBody2D


@export var areaDetect:Area2D
var dropping:bool = false
var returning:bool = false
func _physics_process(delta: float) -> void:
	if move_and_collide(velocity * delta):
		returning = true
	if returning:
		if position.y > 300:
			velocity.y = -40
		#else:
			velocity.y = 0
			position.y = 30
			returning = false
		print(position)
	
	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	dropping = true;
	velocity.y = 50;
	print(body)
	pass # Replace with function body.
