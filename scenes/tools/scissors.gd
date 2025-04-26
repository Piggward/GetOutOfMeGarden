class_name Scissors
extends Tool

const GARDEN_SHEERS = preload("res://assets/farming_tools/GardenSheers.png")
const GARDEN_SHEERS_CLOSED = preload("res://assets/farming_tools/GardenSheers_closed.png")
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var cursor_marker = $CursorMarker

func _ready():
	super._ready()
	offset = cursor_marker.position

func start_performing_action():
	performing_action = true
	sprite_2d.texture = GARDEN_SHEERS_CLOSED
	pass
	
func stop_performing_action():
	performing_action = false
	sprite_2d.texture = GARDEN_SHEERS
	pass

func _process(delta: float) -> void:
	if interactable_areas.size() > 0 and performing_action:
		interactable_areas[0].interact("scissors")
		performing_action = false

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	super._on_event(event)
	pass # Replace with function body.

	
func _on_mouse_entered() -> void:
	mouse_enter = true
	pass # Replace with function body.


func _on_mouse_exited() -> void:
	mouse_enter = false
	pass # Replace with function body.
