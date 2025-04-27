class_name Weed
extends InteractableArea

@onready var animated_sprite_2d: AnimatedSprite2D = $weed_art/AnimatedSprite2D
const GREEN_EXPLOSION_PARTICLES = preload("res://scenes/green_explosion_particles.tscn")
@export var on_hit_kill:bool

var spawn_sounds = [
	preload("res://assets/audio/grass_spawn.wav"),
	preload("res://assets/audio/grass_spawn_2.wav"),
	preload("res://assets/audio/grass_spawn_3.wav"),
	preload("res://assets/audio/grass_spawn_4.wav"),
	preload("res://assets/audio/grass_spawn_5.wav"),
	preload("res://assets/audio/grass_spawn_6.wav"),
	preload("res://assets/audio/grass_spawn_7.wav"),
	preload("res://assets/audio/grass_spawn_8.wav")
]

var death_sounds = [
	preload("res://assets/audio/cut_grass.wav"),
]

func _ready() -> void:
	var audio = $AudioStreamPlayer2D
	audio.stream = spawn_sounds[randi_range(0, spawn_sounds.size()-1)]
	audio.pitch_scale = 1.0 + randf_range(0.2, 0.4)
	audio.play()
func interact(tool_used: String = ""):
	super.interact()
	if tool_used == "scissors":
		self.damage()
	
func damage():
	var expl = GREEN_EXPLOSION_PARTICLES.instantiate()
	get_tree().root.add_child(expl)
	expl.global_position = self.global_position
	expl.emitting = true
	if animated_sprite_2d.frame == 0 or on_hit_kill:
		self.kill()
	else:
		animated_sprite_2d.frame -= 1
	
	var audio = $AudioStreamPlayer2D
	audio.stream = death_sounds[randi_range(0, death_sounds.size()-1)]
	audio.pitch_scale = randf_range(1.0, 1.6)
	audio.play()

func kill():
	animated_sprite_2d.visible = false
	die.emit(self)
	self.queue_free()
