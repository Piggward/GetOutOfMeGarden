class_name Pointer
extends Node2D
@onready var animation_player = $AnimationPlayer

func throw():
	animation_player.play("throw")
	
func bob():
	animation_player.play("bob")
	
func _process(delta):
	var parent = get_parent()
	if parent is Bunny:
		self.global_position = parent.global_position + Vector2(0, -35)
