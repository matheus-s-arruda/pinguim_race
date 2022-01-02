extends Node

signal update_target(value)

var player : Node
var checkpoint_target = null setget _update_checkpoint
var score := 0


func _ready():
	randomize()


func start():
	checkpoint_target = null


func _update_checkpoint(new_target):
	checkpoint_target = new_target
	
	emit_signal("update_target", new_target != null)
