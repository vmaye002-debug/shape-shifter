extends Node2D


var what_to_spawn = preload("res://Circle Enemy/circle_enemy.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	var what: Node2D = what_to_spawn.instantiate()
	get_tree().current_scene.add_child(what)
	what.position = position
