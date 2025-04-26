extends Node2D

@export var spawn_area_size: Vector2 = Vector2(300,300)

@onready var area := $Area 

@export var spawnables: Dictionary = {
	"weed": {
		"scene": preload("res://scenes/weed.tscn"),
		"size": Vector2(16, 16)
	}
}

func _ready():
	position = get_viewport_rect().size / 2
	queue_redraw()
	for i in 10:
		try_spawn_object("weed")
	
func get_spawn_area() -> Rect2:
	return Rect2(position - spawn_area_size / 2, spawn_area_size)
	
func _draw():
	var half = spawn_area_size / 2
	draw_rect(Rect2(-half, spawn_area_size), Color.GREEN, false)
	
func get_random_position(object_size: Vector2) -> Vector2:
	var half_area = spawn_area_size / 2
	var half_object = object_size / 2

	var x = randf_range(-half_area.x + half_object.x, half_area.x - half_object.x)
	var y = randf_range(-half_area.y + half_object.y, half_area.y - half_object.y)

	return position + Vector2(x, y)
	
func is_space_free_at_position(position: Vector2, size: Vector2) -> bool:
	var space_state = get_world_2d().direct_space_state

	var shape = RectangleShape2D.new()
	shape.extents = size / 2  # Godot uses half-size (extents)

	var params = PhysicsShapeQueryParameters2D.new()
	params.shape = shape
	params.transform = Transform2D.IDENTITY.translated(position)
	params.collide_with_areas = true
	params.collide_with_bodies = true

	return space_state.intersect_shape(params, 1).is_empty()
	
func try_spawn_object(name: String):
	var object_to_spawn: PackedScene = spawnables[name]["scene"]
	var object_size: Vector2 = spawnables[name]["size"]
	var try_count = 0
	while true:
		try_count += 1
		if try_count == 5:
			print("[SpawnManager#spawn_object] Failed to find suitable spawnlocation after 5 tries")
			break
		var pos = get_random_position(object_size)
		
		if is_space_free_at_position(pos, object_size):
			var instance = object_to_spawn.instantiate()
			instance.position = pos
			$"SpawnedObjects".add_child(instance)
			print("Spawned %s object at: %s" % [name, pos])
			return  # Object successfully spawned, exit the loop
