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
	Vector2(-2650, 2800),
	Vector2(-650, 2800),
	Vector2(-1350, 2800),
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
var finish := false

func _ready():
	yield(get_tree().create_timer(1), "timeout")
	start()


func start():
	if finish:
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


func spawn_orca():
	var new_pos = orca_spws[6 + (randi() % 3)]
	var new_orca = orca_res.instance()
	call_deferred("add_child", new_orca)
	new_orca.global_position = new_pos


