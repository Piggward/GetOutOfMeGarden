class_name Tool
extends ThrowableBody

@export var efficiency: float = 1

var performing_action: bool = false
var interactable_area: InteractableArea = null

func _ready():
	continuous_cd = RigidBody2D.CCD_MODE_CAST_RAY

func _on_event(event: InputEvent) -> void:
	if event.is_action_pressed("right_click"):
		start_performing_action()
	if event.is_action_released("right_click"):
		stop_performing_action()
	pass # Replace with function body.
	
func on_area_detected(area: Area2D):
	if area is InteractableArea:
		self.interactable_area = area
	
func start_performing_action():
	performing_action = true
	pass
	
func stop_performing_action():
	performing_action = false
	pass
