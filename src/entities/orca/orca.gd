extends KinematicBody2D

const MAX_SPEED := 500.0
const ACCELR_TIME := 5.0

var target := Vector2.ZERO

var _motion := Vector2.ZERO
var _current_speed := 0.0


func _physics_process(delta):
	_particles()
	target = Gameplay.player.global_position
	
	_current_speed = _current_speed + (delta / ACCELR_TIME) if _current_speed < 1.0 else 1.0
	var _angle = (-global_position + target).angle()
	global_rotation =  lerp_angle(global_rotation, _angle, delta * 7.0)
	var _deg_dif = Vector2.RIGHT.rotated(global_rotation).angle_to(-global_position + target)
	$AnimationTree["parameters/turn/blend_amount"] = _deg_dif * 2.0
	
	_motion = move_and_slide(_motion, Vector2.UP)
	#_motion = lerp(_motion, Vector2.RIGHT.rotated(global_rotation) * _current_speed * MAX_SPEED, delta * 2.0)
	_motion = Vector2.RIGHT.rotated(global_rotation) * _current_speed * MAX_SPEED


func _particles():
	$drops.emitting   = _motion.length() > 80.0
	$trail_C.emitting = _motion.length() > 80.0
	$trail_R.emitting = _motion.length() > 80.0
	$trail_L.emitting = _motion.length() > 80.0



