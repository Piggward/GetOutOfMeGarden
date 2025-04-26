class_name Shovel
extends Tool

const TOOL = preload("res://assets/farming_tools/all_tools/Showel.png")
const TOOL_IN_USE = preload("res://assets/farming_tools/all_tools/ShowelDig.png")
@onready var sprite_2d: Sprite2D = $Sprite2D

func start_performing_action():
	performing_action = true
	sprite_2d.texture = TOOL_IN_USE
	pass
	
func stop_performing_action():
	performing_action = false
	sprite_2d.texture = TOOL
	pass

func _process(delta: float) -> void:
	if interactable_areas.size() > 0 and performing_action:
		interactable_areas[0].interact()
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
