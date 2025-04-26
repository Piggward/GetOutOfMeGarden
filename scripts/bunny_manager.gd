extends Node2D

@onready var spawn_area: Node2D = $Area
@onready var spawned_objects: Node2D = $SpawnedObjects
@export var spawn_area_width: float = 500.0  # Width of the spawn area
@export var spawn_area_height: float = 500.0  # Height of the spawn area

var spawn_rate:float
var spawnables: Dictionary = {
	"bunny": {
		"scene": preload("res://scenes/bunny.tscn"),
		"size": Vector2(16,16)
	}
}

func _set_spawn_rate(value:float):
	spawn_rate = value

func set_spawn(value:bool):
	debug_spawn_loop(value)
	

func _ready():
	# Set the spawn area size according to the input values
	spawn_area.position = spawn_area.position  # Just to ensure it's correctly placed in the scene
	spawn_area.scale = Vector2.ONE  # Reset scale, we won't use it anymore
	spawn_area.set("rect_size", Vector2(spawn_area_width, spawn_area_height))  # Adjust size

	queue_redraw()  # Draw the debug border
	


func spawn_object(object_name: String) -> void:
	if not spawnables.has(object_name):
		print("[SpawnManager#spawn_object] Not able to spawn unkown entity: %s" % object_name)
		return
		
	var object_scene = spawnables[object_name]["scene"]
	var object_size = spawnables[object_name]["size"]
	var max_checks = 10
	var pos = get_random_position()
	var instance = object_scene.instantiate()
	instance.position = pos
	instance.z_index = 10  # Make sure it renders in front
	spawned_objects.add_child(instance)

	
func get_random_position() -> Vector2:
	# Use the dimensions directly to get random spawn position within the defined area
	var half_width = spawn_area_width / 2
	var half_height = spawn_area_height / 2
	var x = randf_range(-half_width, half_width)
	var y = randf_range(-half_height, half_height)
	return spawn_area.position + Vector2(x, y)  # Use local position of the area

func debug_spawn_loop(value:bool) -> void:
	while value:
		spawn_object("bunny")
		await get_tree().create_timer(spawn_rate).timeout	
	
