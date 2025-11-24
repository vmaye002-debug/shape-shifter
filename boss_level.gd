extends Node2D

@export var anim_play: AnimationPlayer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_cant_count_this_boss_died() -> void:
	anim_play.play("princessNickCage")
