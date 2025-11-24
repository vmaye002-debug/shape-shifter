extends Sprite2D

const FLOAT_DISTANCE: float = 20.0 
const FLOAT_SPEED: float = 2.0 

var _start_y: float = 0.0
var _time_elapsed: float = 0.0

@export var area: Area2D
@export var ending: PackedScene # This holds your .tscn file

func _ready() -> void:
	_start_y = position.y 

func _process(delta: float) -> void:
	_time_elapsed += delta
	
	var offset_y: float = sin(_time_elapsed * FLOAT_SPEED) * FLOAT_DISTANCE
	
	position.y = _start_y + offset_y

func activate_thyself() -> void:
	area.monitoring = true

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		_play_ending_sequence(body)

func _play_ending_sequence(player_body: Node2D) -> void:
	set_process(false)
	
	if player_body is RigidBody2D:
		player_body.freeze = true
		player_body.linear_velocity = Vector2.ZERO
		player_body.angular_velocity = 0.0
	
	# Create a temporary UI layer for the fade effect
	var canvas_layer = CanvasLayer.new()
	get_tree().root.add_child(canvas_layer)
	
	var fade_rect = ColorRect.new()
	fade_rect.color = Color(0, 0, 0, 0) # Start transparent black
	fade_rect.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	canvas_layer.add_child(fade_rect)
	
	var camera = player_body.get_node_or_null("Camera2D")
	var tween = create_tween()
	
	tween.set_parallel(true)
	
	if camera:
		tween.tween_property(camera, "zoom", Vector2(4.0, 4.0), 2.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

	tween.tween_property(fade_rect, "color:a", 1.0, 2.5)
	
	# CHAIN: Wait for the previous parallel tweens to finish
	tween.chain().tween_callback(func():
		print("Game Over sequence finished.")
		if ending:
			# This actually changes the scene
			get_tree().change_scene_to_packed(ending)
		else:
			push_error("Ending scene not assigned in Inspector!")
	)
