extends TextureProgressBar

#@onready var progress_bar: ProgressBar = $ProgressBar
@onready var spawned_objects: Node2D = $"../../SpawnableArea/SpawnedObjects"
var spawn_manager:SpawnManager


func _ready() -> void:
	spawn_manager = get_tree().get_first_node_in_group("spawn_manager")
	spawn_manager.on_spawn.connect(_update_value)

func _update_value():
	var amount_of_grass_or_roots = spawned_objects.get_children().size()-1
	self.value = amount_of_grass_or_roots
	self.value_changed.emit()
	if value == max_value:
		Global.game_over.emit(false)
	
