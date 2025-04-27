extends Node

@onready var wave_timer: Timer = $WaveTimer
#spawn rates
var weed_timer:Timer
var root_timer:Timer
@export var wave1_weed_amount:float
@export var wave2_weed_amount:float
@export var wave3_weed_amount:float
@export var wave4_weed_amount:float
@export var wave5_weed_amount:float
@export var wave6_weed_amount:float
@export var wave7_weed_amount:float

@export var wave2_root_amount:float
@export var wave3_root_amount:float
@export var wave4_root_amount:float
@export var wave5_root_amount:float
@export var wave6_root_amount:float
@export var wave7_root_amount:float

@export var wave3_bunny_amount:float
@export var wave4_bunny_amount:float
@export var wave5_bunny_amount:float
@export var wave6_bunny_amount:float
@export var wave7_bunny_amount:float

@export var wave4_fish_timer:float = 12
@export var wave5_fish_timer:float = 12
@export var wave6_fish_timer:float = 12
@export var wave7_fish_timer:float = 12


enum GameState {
	START,
	WAVE_1,
	WAVE_2,
	WAVE_3,
	WAVE_4,
	WAVE_5,
	WAVE_6,
	WAVE_7
}

var wave_length = [	13,	13,	13, 13, 13, 30,	30,	30]

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
		GameState.WAVE_4: return GameState.WAVE_5
		GameState.WAVE_5: return GameState.WAVE_6
		GameState.WAVE_6: return GameState.WAVE_7
	print("[GameManager#next_wave] Unkown current_state: [%s], unable to continue... returning to GameStateSTART" % current_state)
	return GameState.START
	
func _on_start_next_wave_timer_timeout() -> void:
	if current_state == GameState.WAVE_7:
		flower_bed.set_growth_stage(4)
		Global.game_over.emit(true)
		return
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
			#bunny_manager.set_spawn(true)
			weed_timer.wait_time=wave3_weed_amount
			root_timer.wait_time = wave3_root_amount			
			flower_progress = GameState.WAVE_2
		GameState.WAVE_4:
			bunny_manager._set_spawn_rate(wave4_bunny_amount)
			weed_timer.wait_time=wave4_weed_amount
			root_timer.wait_time = wave4_root_amount			
			flower_progress = GameState.WAVE_2
		GameState.WAVE_5:
			bunny_manager._set_spawn_rate(wave5_bunny_amount)
			bunny_manager.set_spawn(true)
			weed_timer.wait_time=wave5_weed_amount
			root_timer.wait_time = wave5_root_amount			
			flower_progress = GameState.WAVE_2
			fisherman.start_fish_spawn_timer(wave5_fish_timer)
		GameState.WAVE_6:
			bunny_manager._set_spawn_rate(wave6_bunny_amount)
			#bunny_manager.set_spawn(true)
			weed_timer.wait_time=wave6_weed_amount
			root_timer.wait_time = wave6_root_amount			
			flower_progress = GameState.WAVE_3
			fisherman.start_fish_spawn_timer(wave6_fish_timer)
		GameState.WAVE_7:
			weed_timer.wait_time=wave7_weed_amount
			root_timer.wait_time = wave7_root_amount
			bunny_manager._set_spawn_rate(wave7_bunny_amount)
			fisherman.start_fish_spawn_timer(wave7_fish_timer)
			
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
	start_next_wave_timer.wait_time = wave_length[current_state] # Wait 5.0s for now
	start_next_wave_timer.one_shot = true
	start_next_wave_timer.connect("timeout", Callable(self, "_on_start_next_wave_timer_timeout"))
	start_next_wave_timer.start()


func _on_flower_bed_flowers_died() -> void:
	print("YOU LOSE SCRUB XDP")
	Global.game_over.emit(false)
	pass # Replace with function body.


func _on_audio_stream_player_finished() -> void:
	var next_song = null
	if current_state > main_bg_music.size():
		next_song = main_bg_music[-1]
	else:
		next_song = main_bg_music[(current_state) - 1]
	if main_audio.stream != next_song:
		if current_state == GameState.WAVE_3 and not tranistioned_audio:
			tranistioned_audio = true
			main_audio.stream = main_bg_transition_track
		else:
			main_audio.stream = next_song
	main_audio.stream.loop_mode = AudioStreamWAV.LoopMode.LOOP_DISABLED

	main_audio.play()
