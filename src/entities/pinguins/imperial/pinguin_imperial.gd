extends KinematicBody2D


const MAX_SPEED := 1000.0
const ACCELR_TIME := 4.0

var _input_speed := 0.0
var _input_dir := 0.0

var _motion := Vector2.ZERO
var _current_speed := 0.0



func _physics_process(delta):
	_motion = move_and_slide(_motion, Vector2.UP)
	_current_speed = lerp(_current_speed,  _input_speed * MAX_SPEED, delta / ACCELR_TIME if _input_speed != 0 else delta)
	_motion = Vector2.RIGHT.rotated(global_rotation) * _current_speed


func _input(event):
	_input_speed = Input.get_axis("ui_down", "ui_up")
	_input_dir = Input.get_axis("ui_left", "ui_right")
	

