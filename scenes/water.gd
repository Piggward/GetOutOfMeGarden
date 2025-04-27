extends Area2D

func _on_body_entered(body):
	# Assuming you've set Kanin to a specific layer number (e.g., layer 2)
	if body.collision_layer & (1 << 3):  # Layer 2 (zero-indexed)
		if body.has_method("drown"):
			body.drown()
