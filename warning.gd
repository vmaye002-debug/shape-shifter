extends Sprite2D

@export var total_flashes: int = 3
@export var single_fade_duration: float = 0.5

func _ready() -> void:
	modulate.a = 0.0 
	var tween = create_tween()
	tween.set_loops(total_flashes)
	tween.tween_property(self, "modulate:a", 1.0, single_fade_duration)
	tween.tween_property(self, "modulate:a", 0.0, single_fade_duration)
	tween.finished.connect(queue_free)


func _on_timer_timeout() -> void:
	queue_free()
	
	
