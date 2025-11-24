class_name DeathScreen
extends Control

@export var restart_button: Button

func _ready():
	if restart_button:
		restart_button.pressed.connect(_on_restart_button_pressed)

func _on_restart_button_pressed():

	var current_scene_path = get_tree().current_scene.scene_file_path
	
	call_deferred("reset_scene", current_scene_path)

func reset_scene(path: String):

	get_tree().change_scene_to_file(path)
