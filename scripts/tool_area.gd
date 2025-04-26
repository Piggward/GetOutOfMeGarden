extends Area2D

@onready var bounds_check: Timer = $BoundsCheck
@onready var vatten_kanna_marker: Marker2D = $VattenKannaMarker
@onready var scissor_marker: Marker2D = $ScissorMarker

func _on_body_exited(body: Node2D) -> void:
	if body is Scissors:
		body._setheld(false)
		await get_tree().create_timer(0.2).timeout
		body.linear_velocity = Vector2.ZERO
		body.global_position = scissor_marker.global_position
	if body is WateringCan:
		body._setheld(false)
		await get_tree().create_timer(0.2).timeout
		body.linear_velocity = Vector2.ZERO
		body.global_position = vatten_kanna_marker.global_position
	pass # Replace with function body.
