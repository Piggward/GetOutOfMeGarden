extends Area2D


func _on_body_exited(body):
	if body is Bunny:
		body.kill()
	if body is Stump:
		body.kill()
	pass # Replace with function body.
