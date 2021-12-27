extends GPenguin


func _input(_event):
	input_speed = Input.get_axis("ui_down", "ui_up")
	input_dir = Input.get_axis("ui_left", "ui_right")
	self.input_slide = Input.is_action_pressed("ui_select")





