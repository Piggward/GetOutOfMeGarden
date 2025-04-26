class_name Player
extends CharacterBody2D

var holding: ThrowableBody = null
@onready var cursor = $AnimatedSprite2D
const HAND_ICONS_1 = preload("res://scenes/player/HandIcons1.png")
const HAND_ICONS_2 = preload("res://scenes/player/HandIcons2.png")
const HAND_CLOSED = preload("res://scenes/player/hand_closed.png")
const HAND_OPEN = preload("res://scenes/player/hand_open.png")

func _ready():
	Input.set_custom_mouse_cursor(HAND_OPEN, 0, Vector2(16, 16))
	pass

func can_pick_up():
	return holding == null
	
func release():
	holding = null
	Input.set_custom_mouse_cursor(HAND_OPEN, 0, Vector2(16, 16))
	
func pick_up(body: ThrowableBody): 
	holding = body
	Input.set_custom_mouse_cursor(HAND_CLOSED, 0, Vector2(16, 16))
