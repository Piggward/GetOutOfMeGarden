extends Node

@onready var wave_timer: Timer = $WaveTimer
#spawn rates
@export var wave1_weed_amount:float
@export var wave2_weed_amount:float
@export var wave3_weed_amount:float
@export var wave4_weed_amount:float
@export var wave2_root_amount:float
@export var wave3_root_amount:float
@export var wave4_root_amount:float
@export var wave3_bunny_amount:float
@export var wave4_bunny_amount:float


enum GameState {
	START,
	WAVE_1,
	WAVE_2,
	WAVE_3,
	WAVE_4
}

@onready var bunny_manager: Node2D = $"../BunnyManager"

#var spawn_manager: Node
@onready var spawn_manager: Node = $"../SpawnableArea"
var current_state: GameState = GameState.START

const SpawnManagerScene = preload("res://scenes/spawnable_area.tscn")

func start_game():
	_on_start_next_wave_timer_timeout()

func _ready() -> void:
	wave_timer.stop()
	Global.game_start.connect(start_game)

func next_wave() -> GameState:
	match current_state:
		GameState.START: return GameState.WAVE_1
		GameState.WAVE_1: return GameState.WAVE_2
		GameState.WAVE_2: return GameState.WAVE_3
		GameState.WAVE_3: return GameState.WAVE_4
	print("[GameManager#next_wave] Unkown current_state: [%s], unable to continue... returning to GameStateSTART" % current_state)
	return GameState.START
	
func _on_start_next_wave_timer_timeout() -> void:
	if current_state == GameState.WAVE_4: return
	var next_state = next_wave()
	print("[GameManager#_on_start_next_wave_timer_timeout] Update state from: [%s], to: [%s]" % [current_state, next_state])
	current_state = next_state
	
	# TODO: tell SpawnManager what state we are in/update spawnables objects (and/or their spawnrate)
	match current_state:
		GameState.WAVE_1:
			spawn_manager.start_spawning_object("weed", wave1_weed_amount)
		GameState.WAVE_2:
			spawn_manager.start_spawning_object("weed", wave2_weed_amount)
			spawn_manager.start_spawning_object("root", wave2_root_amount)
		GameState.WAVE_3:
			spawn_manager.start_spawning_object("weed", wave3_weed_amount)
			spawn_manager.start_spawning_object("root", wave3_root_amount)
			bunny_manager._set_spawn_rate(5)
			bunny_manager.set_spawn(true)
		GameState.WAVE_4:
			spawn_manager.start_spawning_object("weed", wave4_weed_amount)
			spawn_manager.start_spawning_object("root", wave4_root_amount)
			# TODO
			pass
	
	wave_timer.start()	

func _on_wave_timer_timeout() -> void:
	wave_timer.stop()
	# TODO: remove all children from SpawnManager$SpawnedObjects
	
	# Just wait 5s for now
	var start_next_wave_timer = Timer.new()
	add_child(start_next_wave_timer)
	if(current_state == GameState.WAVE_3):
		start_next_wave_timer.wait_time = 45.0 # Wait 5.0s for now
	else:
		start_next_wave_timer.wait_time = 20.0 # Wait 5.0s for now
	start_next_wave_timer.one_shot = true
	start_next_wave_timer.connect("timeout", Callable(self, "_on_start_next_wave_timer_timeout"))
	start_next_wave_timer.start()


func _on_flower_bed_flowers_died() -> void:
	print("YOU LOSE SCRUB XDP")
	pass # Replace with function body.
