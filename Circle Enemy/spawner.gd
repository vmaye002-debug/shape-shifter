extends Node2D


var what_to_spawn = preload("res://Circle Enemy/circle_enemy.tscn")
@export var secs_per_spawn: float = 1.5
@export var speed: Vector2 
@onready var tim = $Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tim.wait_time = secs_per_spawn
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	var what: CircleEnemy = what_to_spawn.instantiate()
	if speed:
		what.speed_spawn = speed
	get_tree().current_scene.add_child(what)
	what.position = position
	
