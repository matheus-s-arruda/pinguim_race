class_name GPenguin
extends KinematicBody2D

enum {IN_WATER, IN_TERRAIN}
enum {NORMAL, IN_SLIDE}

const SLIDE_WATER := 1.0
const SLIDE_TERRAIN := 2.0
const MAX_SPEED := 1000.0
const ACCELR_TIME := 4.0
const MAX_ROTATE_SPEED := 0.06

var slide := 1.0
var state = IN_WATER
var substate = NORMAL
var input_speed := 0.0
var input_dir := 0.0
var input_slide := false setget _handle_slide

var _motion := Vector2.ZERO
var _current_speed := 0.0
var _current_rotation := 0.0
var _flag_anim_slide := 0.0

func _physics_process(delta):
	_handle_states(delta)
	_animation()
	
	
	_motion = move_and_slide(_motion, Vector2.UP)
	_current_speed = lerp(_current_speed,  input_speed * MAX_SPEED, delta / ACCELR_TIME if input_speed != 0.0 else delta)
	_motion = lerp(_motion, Vector2.RIGHT.rotated(global_rotation) * _current_speed, delta * slide)
	
	_current_rotation = lerp(_current_rotation, input_dir, delta * 4.0 if input_dir != 0.0 else delta * 8.0)
	global_rotation += _current_rotation * MAX_ROTATE_SPEED * slide


func _animation():
	$AnimationTree["parameters/BlendTree/TimeScale/scale"] = (3.0 - ((_motion.length() / MAX_SPEED) * 2.0)) if input_speed != 0.0 or input_dir != 0.0 else 0.1
	$AnimationTree["parameters/BlendTree/swim_stop/blend_amount"] = 0.9 - (_current_speed / MAX_SPEED)
	$AnimationTree["parameters/BlendTree/left_right/blend_amount"] = _current_rotation
	$AnimationTree["parameters/BlendTree/fins_slide/blend_amount"] = _flag_anim_slide
	$AnimationTree["parameters/BlendTree/fins_motion/scale"] =  (4.0 - ((_motion.length() / MAX_SPEED) * 3.0)) if input_speed != 0.0 or input_dir != 0.0 else 0.1


func _handle_states(delta):
	match state:
		IN_WATER:
			slide = SLIDE_WATER
		
		IN_TERRAIN:
			slide = SLIDE_TERRAIN
	
	match substate:
		NORMAL:
			_flag_anim_slide = _flag_anim_slide - (delta * 4.0) if _flag_anim_slide > 0.0 else 0.0
			
		IN_SLIDE:
			_flag_anim_slide = _flag_anim_slide + (delta * 4.0) if _flag_anim_slide < 1.0 else 1.0
			slide *= 0.5


func _handle_slide(value:bool):
	input_slide = value
	substate = IN_SLIDE if input_slide else NORMAL


