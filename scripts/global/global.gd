extends Node

signal has_picked_up(obj: ThrowableBody)
signal has_interacted(are: InteractableArea)
signal game_start
signal game_over(won: bool)

var has_reloaded: bool = false
var tutorial: bool = true
