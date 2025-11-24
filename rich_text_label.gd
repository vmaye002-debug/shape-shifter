extends RichTextLabel

@export var typing_speed: float = 0.05 


signal display_finished

var current_tween: Tween
var is_typing: bool = false

func _ready():
	# Crucial: Must be enabled for accurate character counts if using tags
	bbcode_enabled = true 
	visible_ratio = 0.0

func display_text(new_text: String):
	text = new_text
	visible_ratio = 0.0
	
	# Get the actual renderable character count (ignores [b], [color] tags, etc)
	var character_count = get_total_character_count()
	var duration = character_count * typing_speed
	
	# Reset previous animation if it exists
	if current_tween:
		current_tween.kill()
		
	current_tween = create_tween()
	is_typing = true
	
	# 1. Animate the text visibility
	current_tween.tween_property(self, "visible_ratio", 1.0, duration)
	
	# 2. Connect finished signal
	current_tween.finished.connect(_on_tween_finished)
	
	# 3. Start the audio loop (fires separately from the tween)
	if character_count > 0:
		_typing_audio_loop()
	else:
		# Handle empty strings instantly
		_on_tween_finished()

func _typing_audio_loop():
	# This loop plays sound at the rhythm of 'typing_speed'
	while is_typing and visible_ratio < 1.0:
		

			
		# Wait for the duration of one character before playing the next sound
		await get_tree().create_timer(typing_speed).timeout

func skip_animation():
	if current_tween and current_tween.is_running():
		current_tween.kill()
		visible_ratio = 1.0
		_on_tween_finished()

func _on_tween_finished():
	is_typing = false
	display_finished.emit()
