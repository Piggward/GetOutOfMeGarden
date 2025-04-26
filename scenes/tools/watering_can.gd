class_name WateringCan
extends Tool

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var water_marker: Marker2D = $WaterMarker

func start_performing_action():
	performing_action = true
	animation_player.play("water")
	for child in water_marker.get_children():
		child.emitting = true
		child.enabled = true
	pass
	
func stop_performing_action():
	performing_action = false
	animation_player.play_backwards("water")
	for child in water_marker.get_children():
		child.emitting = false
		child.enabled = false
	pass

func _process(delta: float) -> void:
	if interactable_area != null and performing_action:
		interactable_area.interact()

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	super._on_event(event)
	pass # Replace with function body.


func _on_detect_interactable_area_area_entered(area: Area2D) -> void:
	super.on_area_detected(area)
	pass # Replace with function body.
