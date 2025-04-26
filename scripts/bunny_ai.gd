extends ThrowableBody
var target_postition:Vector2
var jump_position:Vector2
var flower_bed:FlowerBed

@export var jump_distance:float
@export var jump_speed:float
@export var jump_time:float
@export var kill_flower_distance:float
var isJumping:bool = false
var timer:float = 0

var flower



@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready(): 
	isJumping = false
	flower_bed = get_tree().get_first_node_in_group("flower_bed")
	flower = flower_bed.get_random_alive_flower()
	target_postition = flower.global_position
	
func jump():
	isJumping = true
	var direction = (target_postition - global_position).normalized()
	if(global_position.distance_to(target_postition)<jump_distance):
		jump_position = target_postition
	else:
		jump_position = global_position+direction * jump_distance
	animated_sprite_2d.play("jump")
	
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

func _setheld(value:bool):
	super._setheld(value)
	if(value):
		animated_sprite_2d.play("struggle")
	if(!value):
		animated_sprite_2d.play("idle")
	
	
	
