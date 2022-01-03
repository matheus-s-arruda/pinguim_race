extends Node2D


onready var _tween = $Tween
var completed := false


func _ready():
	cicle()


func _enter_tree():
	Gameplay.checkpoint_target = self


func cicle():
	if completed:
		return
		
	_tween.interpolate_property($Bandeira, "scale", Vector2.ONE, Vector2(1.5, 1.5), 1, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	_tween.interpolate_property($Circulo, "modulate", Color(1, 1, 1, 0.5), Color(1, 1, 1, 1), 1)  
	_tween.start()
	
	yield(_tween, "tween_all_completed")
	_tween.interpolate_property($Bandeira, "scale", Vector2(1.5, 1.5), Vector2.ONE, 1, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	_tween.interpolate_property($Circulo, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0.5), 1)  
	_tween.start()
	
	yield(_tween, "tween_all_completed")
	cicle()


func anim_completed():
	completed = true
	_tween.remove_all()
	_tween.interpolate_property($Circulo, "scale", Vector2(1.5, 1.5), Vector2(2, 2), 0.5)
	_tween.interpolate_property($Circulo, "modulate", $Circulo.modulate, Color(1, 1, 1, 0), 0.5)
	_tween.interpolate_property($Bandeira, "modulate", Color(1, 1, 1, 0.16), Color(1, 1, 1, 0), 0.5)
	_tween.start()
	yield(_tween, "tween_all_completed")
	queue_free()


func _on_flag_body_entered(_body):
	Gameplay.checkpoint_target = null
	get_parent().current_spawn = null
	get_parent().spawn_orca()
	Gameplay.score += 1
	anim_completed()




