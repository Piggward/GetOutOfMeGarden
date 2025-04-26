extends TextureRect

signal next_pressed
var player: Player
const HAND_POINT_E_2 = preload("res://assets/hand_point_e2.png")
func _ready():
	player = get_tree().get_first_node_in_group("player")

func _on_gui_input(event: InputEvent):
	if event.is_action_pressed("left_click"):
		next_pressed.emit()
	pass # Replace with function body.


func _on_mouse_entered():
	player.set_cursor(HAND_POINT_E_2)
	pass # Replace with function body.


func _on_mouse_exited():
	player.reset_cursor()
	pass # Replace with function body.
