extends Camera2D

const MIN_ZOOM := Vector2.ONE
const MAX_ZOOM := Vector2(2.2, 2.2)

var _zoom_target := Vector2(1.5, 1.5)

onready var _pinguim = get_parent()


func _physics_process(delta):
	var _fator = _pinguim._motion.length() / _pinguim.MAX_SPEED
	_zoom_target = MIN_ZOOM + (Vector2.ONE * _fator)

	zoom = lerp(zoom, _zoom_target, delta * 2.0)
	
