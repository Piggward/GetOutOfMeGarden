class_name ThrowableBody
extends RigidBody2D

var is_held = false
var last_mouse_pos = Vector2.ZERO
var throw_velocity = Vector2.ZERO
var player: Player
@export var damp: float = 3.0
@export var max_velocity: float = 500
var mouse_enter = false

func _ready():
	player = get_tree().get_first_node_in_group("player")
	
func _input(event):
	if event.is_action_pressed("left_click") and player.can_pick_up() and mouse_enter:
		_setheld(true)
		freeze = true
		linear_velocity = Vector2.ZERO
		angular_velocity = 0
		linear_damp = 0
	elif event.is_action_released("left_click") and is_held:
		freeze_mode = FreezeMode.FREEZE_MODE_KINEMATIC
		_setheld(false)
		freeze = false
		linear_velocity = throw_velocity.clamp(Vector2(-max_velocity, -max_velocity), Vector2(max_velocity, max_velocity))
		linear_damp = damp

func _physics_process(delta):
	if is_held:
		var mouse_pos = get_global_mouse_position()
		throw_velocity = (mouse_pos - last_mouse_pos) / delta
		global_position = mouse_pos
		last_mouse_pos = mouse_pos

func _setheld(value:bool):
	is_held = value
	if value:
		player.pick_up(self)
	else:
		player.release()
