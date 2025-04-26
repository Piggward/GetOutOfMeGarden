class_name DetectInteractableArea
extends Area2D

signal area_detected(area: InteractableArea)
signal area_left(area: InteractableArea)

func _on_area_entered(area: Area2D) -> void:
	if area is InteractableArea:
		area_detected.emit(area)
	pass # Replace with function body.


func _on_area_exited(area: Area2D) -> void:
	if area is InteractableArea:
		area_left.emit(area)
	pass # Replace with function body.
