extends Node2D



func _init():
	var _err = Gameplay.connect("update_target", self, "update_target")


func _ready():
	set_physics_process(false)


func update_target(value:bool):
	set_physics_process(value)
	visible = value


func _physics_process(_delta):
	if Gameplay.checkpoint_target:
		var seta_target = global_position - Gameplay.checkpoint_target.global_position
		global_rotation = seta_target.angle() + PI
		var _l = (1.0 - (seta_target.length() / 3000))
		$Seta.modulate.a = 0.2 + _l if _l > 0.0 else 0.2



