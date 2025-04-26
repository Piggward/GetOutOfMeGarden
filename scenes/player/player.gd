class_name Player
extends CharacterBody2D

var holding: ThrowableBody = null
@onready var cursor = $AnimatedSprite2D
const HAND_ICONS_1 = preload("res://scenes/player/HandIcons1.png")
const HAND_ICONS_2 = preload("res://scenes/player/HandIcons2.png")
const HAND_CLOSED = preload("res://scenes/player/hand_closed.png")
const HAND_OPEN = preload("res://scenes/player/hand_open.png")

func _ready():
	reset_cursor()
	pass

func can_pick_up():
	return holding == null
	
func release():
	holding = null
	set_cursor(HAND_OPEN)
	
func pick_up(body: ThrowableBody): 
	holding = body
	set_cursor(HAND_CLOSED)
	
func set_cursor(c):
	Input.set_custom_mouse_cursor(c, 0, Vector2(16, 16))
	
func reset_cursor():
	set_cursor(HAND_OPEN)
