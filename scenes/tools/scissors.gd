class_name Scissors
extends Tool

const GARDEN_SHEERS = preload("res://assets/farming_tools/GardenSheers.png")
const GARDEN_SHEERS_CLOSED = preload("res://assets/farming_tools/GardenSheers_closed.png")
@onready var sprite_2d: Sprite2D = $Sprite2D

func start_performing_action():
	performing_action = true
	sprite_2d.texture = GARDEN_SHEERS_CLOSED
	pass
	
func stop_performing_action():
	performing_action = false
	sprite_2d.texture = GARDEN_SHEERS
	pass

func _process(delta: float) -> void:
	if interactable_area != null and performing_action:
		interactable_area.interact()
		performing_action = false

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	super._on_event(event)
	pass # Replace with function body.


func _on_detect_interactable_area_area_entered(area: Area2D) -> void:
	super.on_area_detected(area)
	pass # Replace with function body.
