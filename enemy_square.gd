extends CharacterBody2D


const SPEED = 300.0

@export var areaDetect:Area2D
var dropping:bool = false
func _physics_process(delta: float) -> void:
	
	

	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	print("dropping");
	dropping = true;
	#velocity.y = 500;
	pass # Replace with function body.
