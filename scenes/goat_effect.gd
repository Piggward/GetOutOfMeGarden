extends Area2D

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		# The user clicked the left mouse button
		var click_position = get_global_mouse_position()
		
		# Convert global mouse position to local position relative to the Area2D
		var local_position = to_local(click_position)
		
		# For RectangleShape2D
		var shape = $CollisionShape2D.shape
		var extents = shape.extents
		
		# Check if the point is inside the rectangle
		if local_position.x >= -extents.x and local_position.x <= extents.x and \
		   local_position.y >= -extents.y and local_position.y <= extents.y:
			$GPUParticles2D.emitting = true
			$Timer.start()
			$AudioStreamPlayer2D.play()
			# Do something here


func _on_timer_timeout() -> void:
	#print("stop")
	$GPUParticles2D.emitting = false
