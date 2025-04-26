class_name Tool
extends ThrowableBody

@export var efficiency: float = 1

var performing_action: bool = false
var interactable_areas: Array[InteractableArea] = []

func _ready():
	super._ready()
	continuous_cd = RigidBody2D.CCD_MODE_CAST_SHAPE
	for child in get_children():
		if child is DetectInteractableArea:
			child.area_detected.connect(_on_area_detected)
			child.area_left.connect(_on_area_left)
	
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
	is_held = value
	if value:
		player.pick_up(self)
	else:
		player.release()
		stop_performing_action()
	
func start_performing_action():
	performing_action = true
	pass
	
func stop_performing_action():
	performing_action = false
	pass
