extends RigidBody2D

@export var health:int = 5
var triangles = preload("res://enemy_triangle.tscn")
var squares = preload("res://enemy_square.tscn")



func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	
	pass

func _ready() -> void:
	var spawnTriangle: Node2D = triangles.instantiate()
	pass
