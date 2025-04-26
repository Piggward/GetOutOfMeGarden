extends Node2D
class_name SpawnManager
@onready var spawn_area: Node2D = $Area
@onready var spawned_objects: Node2D = $SpawnedObjects

@export var spawn_area_width: float = 500.0  # Width of the spawn area
@export var spawn_area_height: float = 500.0  # Height of the spawn area

signal on_spawn

var spawnables: Dictionary = {
	"flower": {
		"scene": preload("res://scenes/weeds_art.tscn"),
		"size": Vector2(16,16)
	}
}

func _ready():
	debug_spawn_loop()

func spawn_object(object_name: String) -> void:
	if not spawnables.has(object_name):
		print("[SpawnManager#spawn_object] Not able to spawn unkown entity: %s" % object_name)
		return
		
	var object_scene = spawnables[object_name]["scene"]
	var object_size = spawnables[object_name]["size"]
	var max_checks = 10
	for i in max_checks:
		var pos = get_random_position()
		if is_space_free_at_position(pos, object_size):
			var instance = object_scene.instantiate()
			instance.position = pos
			spawned_objects.add_child(instance)
			on_spawn.emit()
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
	
func debug_spawn_loop() -> void:
	while true:
		spawn_object("flower")
		await get_tree().create_timer(1.0).timeout
		
# UNCOMMENT ME IF YOU WANT TO SEE OUTLINE OF SPAWNABLEAREA!
#func _draw():
	#var half_size := Vector2(spawn_area_width, spawn_area_height) / 2
	#var top_left := spawn_area.position - half_size
	#var rect := Rect2(top_left, half_size * 2)
	#draw_rect(rect, Color.GREEN, false, 2.0)
		
	
