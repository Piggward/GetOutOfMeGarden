extends Node

@onready var wave_timer: Timer = $WaveTimer

enum GameState {
	START,
	WAVE_1,
	WAVE_2,
	WAVE_3
}

var wave_content: Dictionary = {
	GameState.WAVE_1: ["weed"],
	GameState.WAVE_2: ["weed", "root"],
	GameState.WAVE_3: ["weed", "root", "tree"],
}

#var spawn_manager: Node
@onready var spawn_manager: Node = $"../SpawnableArea"
var current_state: GameState = GameState.START

const SpawnManagerScene = preload("res://scenes/spawnable_area.tscn")

func _ready():
	pass
	#spawn_manager = SpawnManagerScene.instantiate()
	#spawn_manager.name = "SpawnManager"
	#spawn_manager.position = Vector2(330.0, 140.0)
	#spawn_manager.spawn_area_height = 140.0
	#spawn_manager.spawn_area_width = 330.0
	#print("parent path: %s" % get_parent().get_path())
	
	#var parent := get_parent()
	#parent.ready.connect(func():
		#parent.add_child(spawn_manager)
		#print("spawn_manger path: %s" % spawn_manager.get_path())
	#)

func next_wave() -> GameState:
	match current_state:
		GameState.START: return GameState.WAVE_1
		GameState.WAVE_1: return GameState.WAVE_2
		GameState.WAVE_2: return GameState.WAVE_3
	print("[GameManager#next_wave] Unkown current_state: [%s], unable to continue... returning to GameStateSTART" % current_state)
	return GameState.START
	
func _on_start_next_wave_timer_timeout() -> void:
	var next_state = next_wave()
	print("[GameManager#_on_start_next_wave_timer_timeout] Update state from: [%s], to: [%s]" % [current_state, next_state])
	current_state = next_state
	
	# TODO: tell SpawnManager what state we are in/update spawnables objects (and/or their spawnrate)
	match current_state:
		GameState.WAVE_1:
			spawn_manager.start_spawning_object("weed", .1)
		GameState.WAVE_2:
			spawn_manager.start_spawning_object("root", .1)
		GameState.WAVE_3:
			spawn_manager.start_spawning_object("flower", .1)
	
	wave_timer.start()	

func _on_wave_timer_timeout() -> void:
	wave_timer.stop()
	# TODO: remove all children from SpawnManager$SpawnedObjects
	
	# Just wait 5s for now
	var start_next_wave_timer = Timer.new()
	add_child(start_next_wave_timer)
	start_next_wave_timer.wait_time = 5.0 # Wait 5.0s for now
	start_next_wave_timer.one_shot = true
	start_next_wave_timer.connect("timeout", Callable(self, "_on_start_next_wave_timer_timeout"))
	start_next_wave_timer.start()
	
	
	
	
