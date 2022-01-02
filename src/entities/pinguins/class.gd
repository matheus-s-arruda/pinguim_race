class_name GPenguin
extends KinematicBody2D

signal motion_less
signal motion_up

enum {IN_WATER, IN_TERRAIN}
enum {NORMAL, IN_SLIDE}

const _fx_wave_idle = preload("res://src/fx/idle_wave.tscn")

const SLIDE_WATER := 1.0
const SLIDE_TERRAIN := 2.0
const MAX_SPEED := 1000.0
const ACCELR_TIME := 4.0
const MAX_ROTATE_SPEED := 0.06

var slide := 1.0
var state = IN_WATER
var substate = NORMAL
var _bonus_speed := 1.0
var input_speed := 0.0
var input_dir := 0.0
var input_slide := false setget _handle_slide

var _motion := Vector2.ZERO setget _handle_motion
var _current_speed := 0.0
var _current_rotation := 0.0
var _flag_anim_slide := 0.0
var _flag_fx_wave_idle := 0.0


func _init():
	var _a = connect("motion_less", self, "_handle_low_motion")
	var _b = connect("motion_up", self, "_handle_most_motion")


func _physics_process(delta):
	_handle_states(delta)
	_animation()
	_fx_waves(delta)
	self._motion = move_and_slide(_motion, Vector2.UP)
	_current_speed = lerp(_current_speed,  input_speed * MAX_SPEED * _bonus_speed, delta / ACCELR_TIME if input_speed != 0.0 else delta)
	self._motion = lerp(_motion, Vector2.RIGHT.rotated(global_rotation) * _current_speed, delta * slide)
	
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
			_bonus_speed = 1.0
			
		IN_SLIDE:
			_flag_anim_slide = _flag_anim_slide + (delta * 4.0) if _flag_anim_slide < 1.0 else 1.0
			slide *= 0.5
			_bonus_speed = 1.3


func _handle_slide(value:bool):
	input_slide = value
	substate = IN_SLIDE if input_slide else NORMAL


func _fx_waves(delta):
	_flag_fx_wave_idle = _flag_fx_wave_idle + delta if _motion.length() < 15.0 else 0
	if _flag_fx_wave_idle > 1.7:
		_flag_fx_wave_idle = 0.0
		var _fx = _fx_wave_idle.instance()
		get_tree().root.call_deferred("add_child", _fx)
		_fx.global_position = global_position


func _handle_motion(_new_motion):
	_motion = _new_motion
	if _motion.length() < 80.0:
		emit_signal("motion_less")
	else:
		emit_signal("motion_up")


func _handle_low_motion():
	$drops.emitting   = false
	$trail_C.emitting = false
	$trail_R.emitting = false
	$trail_L.emitting = false


func _handle_most_motion():
	$drops.emitting   = true
	$trail_C.emitting = true
	$trail_L.emitting = true
	$trail_R.emitting = true




