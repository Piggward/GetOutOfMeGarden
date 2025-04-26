extends RigidBody2D

var is_held = false
var last_mouse_pos = Vector2.ZERO
var throw_velocity = Vector2.ZERO


func _input(event):
	if event.is_action_pressed("left_click") and get_global_mouse_position().distance_to(global_position) < 32:
		is_held = true
		freeze = true
		linear_velocity = Vector2.ZERO
		angular_velocity = 0
		linear_damp = 0
	elif event.is_action_released("left_click") and is_held:
		freeze_mode = FreezeMode.FREEZE_MODE_KINEMATIC
		is_held = false
		freeze = false
		linear_velocity = throw_velocity
		linear_damp = 10

func _physics_process(delta):
	if is_held:
		var mouse_pos = get_global_mouse_position()
		throw_velocity = (mouse_pos - last_mouse_pos) / delta
		global_position = mouse_pos
		last_mouse_pos = mouse_pos
