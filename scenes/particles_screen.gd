extends Node2D

@onready var water_marker = $WateringCan/WaterMarker
@onready var green_explosion = $green_explosion
@onready var spawn_tool_star = $SpawnToolStar
@onready var green_explosion_2 = $green_explosion2

func _ready():
	green_explosion.emitting = true
	spawn_tool_star.emitting = true
	green_explosion_2.emitting = true
	for child in water_marker.get_children():
		child.emitting = true
	
	await get_tree().create_timer(2).timeout
	get_tree().change_scene_to_file("res://scenes/main_scene_art.tscn")
