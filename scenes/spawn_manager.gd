extends Node2D

@onready var spawn_area: Node2D = $Area
@onready var spawned_objects: Node2D = $SpawnedObjects

@export var spawn_area_width: float = 500.0  # Width of the spawn area
@export var spawn_area_height: float = 500.0  # Height of the spawn area

var spawnables: Dictionary = {
	"weed": {
		"scene": preload("res://scenes/weed.tscn"),
		"size": Vector2(16,16)
	}
}

func _ready():
	# Set the spawn area size according to the input values
	spawn_area.position = spawn_area.position  # Just to ensure it's correctly placed in the scene
	spawn_area.scale = Vector2.ONE  # Reset scale, we won't use it anymore
	spawn_area.set("rect_size", Vector2(spawn_area_width, spawn_area_height))  # Adjust size

	queue_redraw()  # Draw the debug border
	
	debug_spawn_loop()

func spawn_object(object_name: String) -> void:
	if not spawnables.has(object_name): return
		
	var object_scene = spawnables[object_name]["scene"]
	var object_size = spawnables[object_name]["size"]
	var max_checks = 10
	for i in max_checks:
		var pos = get_random_position()
		if is_space_free_at_position(pos, object_size):
			var instance = object_scene.instantiate()
			instance.position = pos
			instance.z_index = 10  # Make sure it renders in front
			spawned_objects.add_child(instance)
			return
	print("No available space found to spawn object: [%s] with size: [%s]." % [object_name, object_size])

func get_random_position() -> Vector2:
	# Use the dimensions directly to get random spawn position within the defined area
	var half_width = spawn_area_width / 2
	var half_height = spawn_area_height / 2
	var x = randf_range(-half_width, half_width)
	var y = randf_range(-half_height, half_height)
	return spawn_area.position + Vector2(x, y)  # Use local position of the area

func is_space_free_at_position(pos: Vector2, size: Vector2) -> bool:
	var space_state = get_world_2d().direct_space_state

	var shape = RectangleShape2D.new()
	shape.extents = size / 2

	var params = PhysicsShapeQueryParameters2D.new()
	params.shape = shape
	params.transform = Transform2D.IDENTITY.translated(pos)
	params.collide_with_bodies = true
	params.collide_with_areas = true

	return space_state.intersect_shape(params, 1).is_empty()

func _draw() -> void:
	# Draw the spawn area size using the input dimensions
	var size = Vector2(spawn_area_width, spawn_area_height)
	var half = size / 2
	draw_rect(Rect2(spawn_area.position - half, size), Color.GREEN, false, 2.0)
	
func debug_spawn_loop() -> void:
	while true:
		spawn_object("weed")
		await get_tree().create_timer(.1).timeout
		
	
