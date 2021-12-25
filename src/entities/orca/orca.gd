extends KinematicBody2D

enum {IDLE, MOTION}
const MAX_SPEED := 250.0
const ACCELR_TIME := 3.0

var state = IDLE
var target := Vector2.ZERO

var _current_speed := 0.0 setget _handle_update_speed
var _anim_transition := 0.0
var _anim_lateral_transition := 0.0
var _anim_lateral_motion := 0.0
var _flag_rotation := 0.0

onready var _anim_tree = $AnimationTree["parameters/playback"]


func _physics_process(delta):
	_handle_states()
	_statemachine(delta)
	
	global_position += Vector2.DOWN.rotated(global_rotation) * _current_speed * cos(_anim_tree.get_current_play_position() * PI * 0.5 )
	var _motion = move_and_slide(Vector2.RIGHT.rotated(global_rotation) * _current_speed * MAX_SPEED, Vector2.UP)


func _input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			target = get_global_mouse_position()


func _handle_states():
	if target != Vector2.ZERO:
		if global_position.distance_to(target) < 150:
			target = Vector2.ZERO
		else:
			state = MOTION
	else:
		state = IDLE


func _statemachine(delta):
	match state:
		IDLE:
			$AnimationTree["parameters/BlendTree/fins/add_amount"] = 0
			self._current_speed = _current_speed - (delta / ACCELR_TIME) if _current_speed > 0.0 else 0.0
		MOTION:
			$AnimationTree["parameters/BlendTree/fins/add_amount"] = 1
			$AnimationTree["parameters/BlendTree/left_right/blend_amount"] = _anim_lateral_transition
			self._current_speed = _current_speed + (delta / ACCELR_TIME) if _current_speed < 1.0 else 1.0
			var _angle = (-global_position + target).angle()
			global_rotation = lerp_angle(global_rotation, _angle, delta)
			var _deg_dif = Vector2.RIGHT.rotated(global_rotation).angle_to(-global_position + target)
			_anim_lateral_transition = _deg_dif if abs(_deg_dif) < 1.0 else 1.0 * sign(_deg_dif)


func _lateral_motion():
	var _zig_zag = cos(_anim_tree.get_current_play_position() * PI * 0.5 )
	global_position += Vector2.DOWN.rotated(global_rotation) * _zig_zag * _current_speed


func _handle_update_speed(new_speed:float):
	_current_speed = new_speed
	$AnimationTree["parameters/BlendTree/TimeScale/scale"] = 1.0 + _current_speed
	$AnimationTree["parameters/BlendTree/stop_move/blend_amount"] = 0.85 - _current_speed


