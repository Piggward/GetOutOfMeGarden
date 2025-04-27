class_name Tool
extends ThrowableBody

@export var efficiency: float = 1

var performing_action: bool = false
var interactable_areas: Array[InteractableArea] = []
var audio = null
var already_picked_up = false

var pickup_sounds = [
	preload("res://assets/audio/klock_0.wav"),
	#preload("res://assets/audio/klock_1.wav"),
	#preload("res://assets/audio/klock_2.wav"),
	#preload("res://assets/audio/klock_3.wav"),
	#preload("res://assets/audio/klock_4.wav"),
]
func _ready():
	super._ready()
	continuous_cd = RigidBody2D.CCD_MODE_CAST_SHAPE
	for child in get_children():
		if child is DetectInteractableArea:
			child.area_detected.connect(_on_area_detected)
			child.area_left.connect(_on_area_left)
	if not audio:
		audio = AudioStreamPlayer2D.new()
		audio.volume_db = -11.0
		add_child(audio)

func _on_area_detected(area: InteractableArea):
	interactable_areas.append(area)
	if not area.die.is_connected(_on_area_left):
		area.die.connect(_on_area_left)
	
func _on_area_left(area):
	if interactable_areas.has(area):
		interactable_areas.erase(area)

func _on_event(event: InputEvent) -> void:
	if player.holding != self:
		return
	if event.is_action_pressed("right_click"):
		start_performing_action()
	if event.is_action_released("right_click"):
		stop_performing_action()
	pass # Replace with function body.
	
func _setheld(value:bool):
	super._setheld(value)
	stop_performing_action()
	if audio.playing:
		return
	audio.stream = pickup_sounds[randi_range(0, pickup_sounds.size()-1)]
		
	if value and not already_picked_up:
		print("picked up")
		already_picked_up = true
		audio.pitch_scale = 1.0 + randf_range(0.2, 0.3)
		audio.play()
	elif not value and already_picked_up:
		print("put down")
		already_picked_up = false
		audio.pitch_scale = 1.0 + randf_range(-0.5, -0.4)
		audio.play()
	
func start_performing_action():
	performing_action = true
	pass
	
func stop_performing_action():
	performing_action = false
	pass
