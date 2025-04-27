extends Node

@onready var wave_timer: Timer = $WaveTimer
#spawn rates
var weed_timer:Timer
var root_timer:Timer
@export var wave1_weed_amount:float
@export var wave2_weed_amount:float
@export var wave3_weed_amount:float
@export var wave4_weed_amount:float
@export var wave2_root_amount:float
@export var wave3_root_amount:float
@export var wave4_root_amount:float
@export var wave3_bunny_amount:float
@export var wave4_bunny_amount:float

@export var wave4_fish_timer:float = 10


enum GameState {
	START,
	WAVE_1,
	WAVE_2,
	WAVE_3,
	WAVE_4
}

@onready var bunny_manager: Node2D = $"../BunnyManager"
@onready var fisherman: Node2D = $"../Fisherman"
@onready var flower_bed: FlowerBed = $"../FlowerBed"

var main_bg_music: Array[AudioStreamWAV] = [
	preload("res://assets/audio/main_loop_1.wav"),
	preload("res://assets/audio/main_loop_2.wav"),
	preload("res://assets/audio/main_loop_3.wav"),
	preload("res://assets/audio/main_loop_4.wav")
]
var main_bg_transition_track: AudioStreamWAV = preload("res://assets/audio/main_loop_2_5.wav")
@onready var main_audio: AudioStreamPlayer = $AudioStreamPlayer
var tranistioned_audio = false
#var spawn_manager: Node
@onready var spawn_manager: Node = $"../SpawnableArea"
var current_state: GameState = GameState.START

const SpawnManagerScene = preload("res://scenes/spawnable_area.tscn")

func start_game():
	main_audio.stream = main_bg_music[0]
	main_audio.stream.loop_mode = AudioStreamWAV.LoopMode.LOOP_DISABLED
	main_audio.start_fade_in()
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
	var flower_progress = current_state
	match current_state:
		GameState.WAVE_1:
			weed_timer = spawn_manager.start_spawning_object("weed", wave1_weed_amount)
		GameState.WAVE_2:
			weed_timer.wait_time = wave2_weed_amount
			root_timer = spawn_manager.start_spawning_object("root", wave2_root_amount)
		GameState.WAVE_3:
			bunny_manager._set_spawn_rate(wave3_bunny_amount)
			bunny_manager.set_spawn(true)
			weed_timer.wait_time=wave3_weed_amount
			root_timer.wait_time = wave3_root_amount
		GameState.WAVE_4:
			weed_timer.wait_time=wave4_weed_amount
			root_timer.wait_time = wave4_root_amount
			bunny_manager._set_spawn_rate(wave4_bunny_amount)
			fisherman.start_fish_spawn_timer(wave4_fish_timer)
			flower_progress = GameState.WAVE_3
			pass
	flower_bed.set_growth_stage(flower_progress)
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
		start_next_wave_timer.wait_time = 12.0 # Wait 5.0s for now
	start_next_wave_timer.one_shot = true
	start_next_wave_timer.connect("timeout", Callable(self, "_on_start_next_wave_timer_timeout"))
	start_next_wave_timer.start()


func _on_flower_bed_flowers_died() -> void:
	print("YOU LOSE SCRUB XDP")
	pass # Replace with function body.


func _on_audio_stream_player_finished() -> void:
	var next_song = main_bg_music[(current_state) - 1]
	if main_audio.stream != next_song:
		if current_state == GameState.WAVE_3 and not tranistioned_audio:
			tranistioned_audio = true
			main_audio.stream = main_bg_transition_track
		else:
			main_audio.stream = next_song
	main_audio.stream.loop_mode = AudioStreamWAV.LoopMode.LOOP_DISABLED

	main_audio.play()
