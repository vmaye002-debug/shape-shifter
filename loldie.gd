class_name DeathScreen
extends Control

@export var restart_button: Button

func _ready():
	if restart_button:
		restart_button.pressed.connect(_on_restart_button_pressed)


func _on_restart_button_pressed():
	get_tree().reload_current_scene()
	
	queue_free()
