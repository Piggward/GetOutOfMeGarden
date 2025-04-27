class_name Bunny
extends ThrowableBody
var target_postition:Vector2
var jump_position:Vector2
var flower_bed:FlowerBed

@export var jump_distance:float
@export var jump_speed:float
@export var jump_time:float
@export var kill_flower_distance:float = 10
var isJumping:bool = false
var timer:float = 0
@onready var cursor_marker = $CursorMarker
var has_pointer: bool = false

var has_been_seen = false
var unkillable = false
var flower
signal died

var yeat_sounds = [
	preload("res://assets/audio/bunny_yeat.wav"),
	preload("res://assets/audio/bunny_yeat_2.wav"),
	preload("res://assets/audio/bunny_yeat_3.wav"),
	preload("res://assets/audio/bunny_yeat_4.wav"),
]

var bunny_jump_sounds = [
	preload("res://assets/audio/bunny_jump.wav"),
	preload("res://assets/audio/bunny_jump2.wav"),
	preload("res://assets/audio/bunny_jump3.wav"),
]
var bunny_eat_sounds = [
	preload("res://assets/audio/bunny_eat.wav"),
	preload("res://assets/audio/bunny_eat2.wav"),
	preload("res://assets/audio/bunny_eat3.wav"),
]
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready(): 
	super._ready()
	isJumping = false
	flower_bed = get_tree().get_first_node_in_group("flower_bed")
	flower = flower_bed.get_random_alive_flower()
	target_postition = flower.global_position
	offset = cursor_marker.position
	pick_up_action = "right_click"
	
func kill():
	print("I DIE")
	die.emit()
	if has_pointer:
		for child in get_children():
			if child.name == "Pointer":
				child.reparent(get_parent())
	self.queue_free()
	
	
func jump():
	isJumping = true
	var direction = (target_postition - global_position).normalized()
	if(global_position.distance_to(target_postition)<jump_distance):
		jump_position = target_postition
	else:
		jump_position = global_position+direction * jump_distance
	animated_sprite_2d.play("jump")
	if $AudioListener2D.stream not in bunny_jump_sounds:
		$AudioListener2D.stream = bunny_jump_sounds.pick_random()
		$AudioListener2D.pitch_scale = randf_range(1.0, 1.1)
		$AudioListener2D.play()
	
func _process(delta: float) -> void:
	if(is_held):
		timer=0
		isJumping =false
		return
	if(isJumping):
		global_position = global_position.lerp(jump_position,jump_speed*delta)
		if(global_position.distance_to(jump_position)<1):
			isJumping=false
			timer=0
	else:
		timer += delta
		if(timer > jump_time):
			jump()
	if(global_position.distance_to(target_postition)<kill_flower_distance):
		flower._kill()
		if $AudioListener2D.stream not in bunny_eat_sounds:
			$AudioListener2D.stream = bunny_eat_sounds.pick_random()
			$AudioListener2D.pitch_scale = randf_range(1.0, 1.5)
			$AudioListener2D.play()

func _setheld(value:bool):
	super._setheld(value)
	if(value):
		animated_sprite_2d.play("struggle")
	if(!value):
		animated_sprite_2d.play("idle")
		if not $AudioListener2D.playing:
			$AudioListener2D.stream = yeat_sounds.pick_random()
			$AudioListener2D.pitch_scale = randf_range(1.0, 1.5)
			$AudioListener2D.play()
		global_position = global_position
	
func _on_mouse_entered() -> void:
	mouse_enter = true
	pass # Replace with function body.

func _on_mouse_exited() -> void:
	mouse_enter = false
	pass # Replace with function body.


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	died.emit()
	if unkillable:
		return
	if has_been_seen:
		print("bunny dead")
		queue_free()

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	has_been_seen = true
