extends CharacterBody2D


const SPEED = 300.0

@export var areaDetect:Area2D


var dropping:bool = false
var returning:bool = false

func _physics_process(delta: float) -> void:
	var collision = move_and_collide(velocity * delta)
	if collision:
		returning = true
	if returning:
		if (position.y > 300):
			velocity.y = -300
		else:
			velocity.y = 0;
			position.y = 300;
			returning = false


func _on_area_2d_body_entered(body: Node2D) -> void:
	dropping = true;
	velocity.y = 500;
	pass # Replace with function body.


func _on_ready() -> void:
	position.y = 300;
	pass # Replace with function body.
