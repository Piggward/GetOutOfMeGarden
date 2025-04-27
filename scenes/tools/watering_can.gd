class_name WateringCan
extends Tool

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var water_marker: Marker2D = $WaterMarker
@onready var detect_interactable_area: Area2D = $DetectInteractableArea
var holding_action = false
@onready var cursor_marker = $CursorMarker

func _ready():
	super._ready()
	offset = cursor_marker.position

func start_performing_action():
	animation_player.play("water")
	holding_action = true
	$AudioStreamPlayer2D.play()
	pass
	
func start_watering():
	if not holding_action:
		return
	performing_action = true
	for child in water_marker.get_children():
		child.emitting = true
	
func stop_performing_action():
	if $AudioStreamPlayer2D.playing:
		$AudioStreamPlayer2D.stop()
	if not holding_action:
		return
	reset()
	pass

func reset():
	holding_action = false
	performing_action = false
	animation_player.play("RESET")

func _process(delta: float) -> void:
	if interactable_areas.size() > 0 and performing_action:
		interactable_areas[0].interact("watering")

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	super._on_event(event)
	pass # Replace with function body.

	
func _on_mouse_entered() -> void:
	mouse_enter = true
	pass # Replace with function body.


func _on_mouse_exited() -> void:
	mouse_enter = false
	pass # Replace with function body.
