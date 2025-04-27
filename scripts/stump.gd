class_name Stump
extends ThrowableBody


func _ready():
	super._ready()
	throw_randomly()

func throw_randomly():
	var speed = 300  # How fast you want to throw it
	var angle = randf() * TAU  # TAU = 2π, full circle
	var velocity = Vector2(cos(angle), sin(angle)) * speed
	linear_velocity = velocity
	linear_damp = 15


func _on_mouse_entered():
	mouse_enter = true
	pass # Replace with function body.


func _on_mouse_exited():
	mouse_enter = false
	pass # Replace with function body.

func kill():
	print("stump dying")
	die.emit()
	self.queue_free()
