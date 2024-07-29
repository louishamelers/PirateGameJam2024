extends SpringArm3D


# Called when the node enters the scene tree for the first time.
func handle_camera():
	if Input.is_action_just_pressed("rotate_left"):
		var tween = create_tween()
		tween.set_trans(Tween.TRANS_SINE)
		tween.set_ease(Tween.EASE_OUT)
		tween.tween_property(
			self,
			"rotation:y",
			self.rotation.y + PI/2,
			0.5
		)
	elif Input.is_action_just_pressed("rotate_right"):
		var tween = create_tween()
		tween.set_trans(Tween.TRANS_SINE)
		tween.set_ease(Tween.EASE_OUT)
		tween.tween_property(
			self,
			"rotation:y",
			self.rotation.y + PI/2,
			0.5
		)

func handle_zoom():
	handle_camera()
	var tween
	if Input.is_action_just_pressed("zoom_in"):
		if spring_length >= 1:
			var new_length = spring_length - 1
			tween.tween_property(
				self,
				"rotation:y",
				self.rotation.y + PI/2,
				0.5
			)
	elif Input.is_action_just_pressed("zoom_out"):
		if spring_length < 4:
			var new_length= spring_length + 1
			tween.tween_property(
				self,
				"rotation:y",
				self.rotation.y + PI/2,
				0.5
			)
