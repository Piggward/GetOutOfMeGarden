class_name Root
extends InteractableArea

@onready var animated_sprite_2d: AnimatedSprite2D = $root_art/AnimatedSprite2D
const GREEN_EXPLOSION_PARTICLES = preload("res://scenes/green_explosion_particles.tscn")
var spawn_sounds = [
	preload("res://assets/audio/root_spawn_1.wav"),
	preload("res://assets/audio/root_spawn_2.wav"),
]

func _ready() -> void:
	var audio = $AudioStreamPlayer2D
	audio.stream = spawn_sounds[randi_range(0, spawn_sounds.size()-1)]
	audio.pitch_scale = 1.0 + randf_range(-0.3, -0.2)
	audio.play()

func interact(tool_used: String = ""):
	super.interact()
	if tool_used == "shovel":
		print("hit me")
		self.damage()
	
func damage():
	var expl = GREEN_EXPLOSION_PARTICLES.instantiate()
	get_tree().root.add_child(expl)
	expl.global_position = self.global_position
	expl.emitting = true
	if animated_sprite_2d.frame == 0:
		self.kill()
	else:
		animated_sprite_2d.frame -= 1
	
func kill():
	die.emit(self)
	self.queue_free()
