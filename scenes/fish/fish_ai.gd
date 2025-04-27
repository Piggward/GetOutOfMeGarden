extends ThrowableBody
class_name Fish

var path_follow = null
var target_progress = 0.0

var spawn_sound = preload("res://assets/audio/fish_jump.wav")

func _ready(): 
	super._ready()
	$AudioStreamPlayer2D.stream = spawn_sound
	$AudioStreamPlayer2D.play()
	contact_monitor = true

func _physics_process(delta: float) -> void:
	super(delta)
	if(is_held):
		return

	if path_follow:
		# Move along the path
		target_progress += 200 * delta
		
		# Apply smoothly
		path_follow.progress = target_progress

		# Optional: Get the path direction to rotate the fish
		if path_follow.get_parent() is Path2D:
			var path = path_follow.get_parent() as Path2D
			var curve = path.curve
			
			# Only rotate if we're not at the end of the path
			if path_follow.progress_ratio < 1.0:
				# Get the rotation from the transform directly
				var transform_2 = curve.sample_baked_with_rotation(path_follow.progress)
				# The basis of the transform contains the rotation information
				rotation = transform_2.get_rotation()

		if path_follow.progress_ratio == 1.0:        
			var global_pos = global_position
			var global_rot = global_rotation
			var new_parent = get_parent().get_parent().get_parent()

			path_follow.remove_child(self)
			new_parent.add_child(self)
			
			# Preserve the global transform
			global_position = global_pos
			global_rotation = global_rot
			path_follow = null
			
		
func spawn(path: PathFollow2D):
	path_follow = path

func _setheld(value:bool):
	super._setheld(value)
	if not value:
		global_position = global_position
	
func _on_mouse_entered() -> void:
	mouse_enter = true

func _on_mouse_exited() -> void:
	mouse_enter = false


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_body_entered(body: Node) -> void:
	if body.is_in_group("water") or body.get_collision_layer_bit(9):  # Assuming "water" is layer 1
		print("Collided with water area!")
