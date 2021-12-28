extends Node2D


onready var anim_tree = $AnimationTree


func _physics_process(delta):
	position += Vector2.UP.rotated(rotation) * 1
	rotation_degrees -= delta * 2






