extends Node2D

enum {CRITICAL_LOOP}

const checkpoint = preload("res://src/fx/check_point.tscn")
const orca_res = preload("res://src/entities/orca/orca.tscn")

const spws := [
	Vector2(1872, -1792),
	Vector2(-368, -1504),
	Vector2(-3200, -2032),
	Vector2(-1888, -480),
	Vector2(-3232, 1040),
	Vector2(-1440, 1904),
	Vector2(-3200, 3088),
	Vector2(128, 3184),
	Vector2(2032, 2832),
	Vector2(1168, 688),
]

const orca_spws := [
	Vector2(-2650, -2800),
	Vector2(-650, -2800),
	Vector2(1950, -2800),
	Vector2(2950, -2000),
	Vector2(2950, 400),
	Vector2(2950, 2900),
	Vector2(2300, 3900),
	Vector2(-430, 3900),
	Vector2(-3200, 3900),
	Vector2(-4000, 3100),
	Vector2(-4000, 530),
	Vector2(-4000, -2000),
]

var fishs := 0
var current_spawn = null setget _update_spawn
var game_end := false
var first_warnning := true


onready var timer = $Timer
onready var _notify = $GUI/HUD/canvas/notify

func _init():
	Gameplay.score = 0


func _ready():
	$Tween.interpolate_property(self, "modulate", Color.black, Color.white, 1)
	$Tween.start()
	yield(get_tree().create_timer(1), "timeout")
	start()
	timer.start(90)


func start():
	if game_end:
		return
	var new_pos = get_spawn_pos()
	if new_pos is Vector2:
		var new_checkpoint = checkpoint.instance()
		call_deferred("add_child", new_checkpoint)
		new_checkpoint.global_position = new_pos
		self.current_spawn = new_checkpoint


func get_spawn_pos():
	var try := 10
	while try > 0:
		try -= 1
		var new_pos = spws[randi() % 10]
		if current_spawn != new_pos:
			return new_pos
	return CRITICAL_LOOP


func _update_spawn(value):
	current_spawn = value
	if not current_spawn:
		start()
		if first_warnning:
			first_warnning = false
			_notify.notify("Orcas on the loose!")


func spawn_orca():
	var new_pos = orca_spws[randi() % 9]
	var new_orca = orca_res.instance()
	new_orca.global_position = new_pos
	call_deferred("add_child", new_orca)


func _on_Timer_timeout():
	timer.stop()
	good_end()


func good_end():
	game_end = true
	$Tween.interpolate_property(self, "modulate", Color.white, Color.black, 1)
	$Tween.start()
	get_tree().paused = true
	yield(get_tree().create_timer(1),"timeout")
	get_tree().paused = false
	var _err = get_tree().change_scene("res://src/GUI/good_end.tscn")


func bad_end():
	if game_end:
		return
	var _err = get_tree().change_scene("res://src/GUI/bad_end.tscn")

