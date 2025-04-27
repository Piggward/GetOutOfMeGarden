extends Area2D

@onready var bounds_check: Timer = $BoundsCheck
@onready var vatten_kanna_marker: Marker2D = $VattenKannaMarker
@onready var scissor_marker: Marker2D = $ScissorMarker
@onready var shovel_marker = $ShovelMarker
const SPAWN_TOOL_PARTICLE = preload("res://scenes/spawn_tool_particle.tscn")

func _on_body_exited(body: Node2D) -> void:
	if body is Scissors:
		body._setheld(false)
		body.linear_velocity = Vector2.ZERO
		body.visible = false
		var spawn = SPAWN_TOOL_PARTICLE.instantiate()
		scissor_marker.add_child(spawn)
		await get_tree().create_timer(1).timeout
		spawn.emitting = true
		body.global_position = scissor_marker.global_position
		body.visible = true
	if body is WateringCan:
		body.holding_action = true
		body._setheld(false)
		body.linear_velocity = Vector2.ZERO
		body.visible = false
		var spawn = SPAWN_TOOL_PARTICLE.instantiate()
		vatten_kanna_marker.add_child(spawn)
		await get_tree().create_timer(1).timeout
		spawn.emitting = true
		body.global_position = vatten_kanna_marker.global_position
		body.visible = true
	if body is Shovel:
		body._setheld(false)
		body.linear_velocity = Vector2.ZERO
		body.visible = false
		var spawn = SPAWN_TOOL_PARTICLE.instantiate()
		shovel_marker.add_child(spawn)
		await get_tree().create_timer(1).timeout
		spawn.emitting = true
		body.global_position = shovel_marker.global_position
		body.visible = true
	pass # Replace with function body.
