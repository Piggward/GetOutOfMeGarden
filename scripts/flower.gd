extends InteractableArea
class_name  Flower
var max_water_liters = 20.0     # Maximum water at time
var current_water_liters = 20.0  # Current watering progress

var can_interact = true
var start_sprite_id = null
var cur_sprite_id = null
var is_dead = false

@onready var interaction_timer = $InteractionTimer
@onready var growth_timer = $GrowTimer
@onready var water_level: ProgressBar = $ProgressBar
var watering_speed_factor = 0.2
var watering_speed = 0
@onready var sprite_sheet = $Sprite2D

enum progress {SEED = 0, SEEDING = 1, SPROUTING = 2, VEGETATION = 3, GROWN = 4, DEAD = 5}
signal flower_died

func is_interactable(tool: String):
	if tool == 'VattenKanna':
		return true
	return false

func interact():
	if not can_interact:
		return
	
	can_interact = false
	interaction_timer.start(0.2)
	
	if current_water_liters >= max_water_liters:
		return
	elif current_water_liters < max_water_liters:
		current_water_liters += watering_speed

func set_growth_stage(id: int):
	cur_sprite_id = start_sprite_id + id
	sprite_sheet.frame = cur_sprite_id
	current_water_liters = max_water_liters
	growth_timer.paused = false

func _ready():
	watering_speed = max_water_liters/watering_speed_factor
	growth_timer.paused = false
# GROW
func _on_grow_timer_timeout() -> void:
	if current_water_liters > 0:
		current_water_liters -= 1
	#print("losing water " + str((current_water_liters/max_water_liters) * 100))
	water_level.value = (current_water_liters/max_water_liters) * 100
	if current_water_liters == 0:
		_kill()
		

func _on_interaction_timer_timeout() -> void:
	can_interact = true

func _kill():
	is_dead = true
	set_growth_stage(progress.DEAD)
	growth_timer.paused = true
	flower_died.emit(self)
