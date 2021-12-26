extends KinematicBody2D


const MAX_SPEED := 1000.0
const ACCELR_TIME := 4.0
const MAX_ROTATE_SPEED := 0.06

var _input_speed := 0.0
var _input_dir := 0.0

var _motion := Vector2.ZERO
var _current_speed := 0.0
var _current_rotation := 0.0


func _physics_process(delta):
	_animation()
	_motion = move_and_slide(_motion, Vector2.UP)
	_current_speed = lerp(_current_speed,  _input_speed * MAX_SPEED, delta / ACCELR_TIME if _input_speed != 0.0 else delta)
	_motion = Vector2.RIGHT.rotated(global_rotation) * _current_speed
	
	_current_rotation = lerp(_current_rotation, _input_dir, delta * 4.0 if _input_dir != 0.0 else delta * 8.0)
	global_rotation += _current_rotation * MAX_ROTATE_SPEED


func _animation():
	$AnimationTree["parameters/BlendTree/swim_stop/blend_amount"] = 0.9 - (_current_speed / MAX_SPEED)
	$AnimationTree["parameters/BlendTree/left_right/blend_amount"] = _current_rotation
	$AnimationTree["parameters/BlendTree/fins_slide/blend_amount"]
	$AnimationTree["parameters/BlendTree/fins_motion/scale"] =  0.1 + (_input_speed * (6.0 - ((_current_speed / MAX_SPEED) * 5.0)))


func _input(_event):
	_input_speed = Input.get_axis("ui_down", "ui_up")
	_input_dir = Input.get_axis("ui_left", "ui_right")
	

