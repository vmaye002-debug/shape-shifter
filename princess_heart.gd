extends Sprite2D

const FLOAT_DISTANCE: float = 20.0 
const FLOAT_SPEED: float = 2.0 

var _start_y: float = 0.0
var _time_elapsed: float = 0.0

func _ready() -> void:
	_start_y = position.y 
	pass


func _process(delta: float) -> void:
	_time_elapsed += delta
	
	var offset_y: float = sin(_time_elapsed * FLOAT_SPEED) * FLOAT_DISTANCE
	
	position.y = _start_y + offset_y
