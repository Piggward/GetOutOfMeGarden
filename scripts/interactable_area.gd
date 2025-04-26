class_name InteractableArea
extends Area2D

signal die(area: InteractableArea)

func is_interactable(tool: String):
	pass

func interact(tool: String = ""):
	if Global.tutorial:
		Global.has_interacted.emit(self)
	pass
