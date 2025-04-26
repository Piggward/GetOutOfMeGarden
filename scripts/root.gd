class_name Root
extends InteractableArea

@onready var animated_sprite_2d: AnimatedSprite2D = $root_art/AnimatedSprite2D
const GREEN_EXPLOSION_PARTICLES = preload("res://scenes/green_explosion_particles.tscn")

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
