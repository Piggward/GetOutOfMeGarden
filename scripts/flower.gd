extends InteractableArea

var goal_water_liters = 10   # Total amount of water to collect
var total_water_liters = 0    # Total water currently collected
var max_water_liters = 10     # Maximum water at time
var current_water_liters = 0  # Current watering progress

var is_dry = true
var can_interact = true
var start_sprite_id = null
var cur_sprite_id = null
@onready var interaction_timer = $InteractionTimer
@onready var sprite_sheet = $Sprite2D

func is_interactable(tool: String):
	if tool == 'VattenKanna':
		return true
	return false

func interact():
	if not can_interact:
		return
	
	can_interact = false
	interaction_timer.start(0.2)

	if is_dry:
		print("no longer dry")
		is_dry = false
		cur_sprite_id += 5
		sprite_sheet.frame = cur_sprite_id
	

func set_sprite_start_id(id: int):
	start_sprite_id = id
	cur_sprite_id = id
	is_dry = true
	sprite_sheet.frame = cur_sprite_id

# TODO: REMOVE THIS LINE ONCE WATERING WORKS
#func _ready():
#	set_sprite_start_id(0)
#	interact()

# GROW
func _on_grow_timer_timeout() -> void:
	print("growing " + str(total_water_liters))
	# current_water_liters = 2  # TODO: REMOVE THIS LINE ONCE WATERING WORKS
	if current_water_liters > 0:
		current_water_liters -= 1
		total_water_liters += 1
	
	if is_dry:
		return
	
	if not is_dry and current_water_liters == 0:
		print("We are dry")
		cur_sprite_id -= 5
		is_dry = true
		return

	# Set sprite according to progress
	var growth_progress = float(total_water_liters)/float(goal_water_liters)
	var new_sprite_id = cur_sprite_id
	if growth_progress >= 1.0:
		new_sprite_id = 4
	elif growth_progress > 0.8:
		new_sprite_id = 3
	elif growth_progress > 0.6:
		new_sprite_id = 2
	elif growth_progress > 0.2:
		new_sprite_id = 1
	
	if new_sprite_id != cur_sprite_id:
		print("new frame")
		cur_sprite_id = start_sprite_id + new_sprite_id
		sprite_sheet.frame = cur_sprite_id
		
func _on_interaction_timer_timeout() -> void:
	can_interact = true
