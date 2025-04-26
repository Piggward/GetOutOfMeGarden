class_name Weed
extends InteractableArea

@onready var animated_sprite_2d: AnimatedSprite2D = $weed_art/AnimatedSprite2D

func interact():
	self.damage()
	
func damage():
	if animated_sprite_2d.frame == 0:
		self.kill()
	else:
		animated_sprite_2d.frame -= 1
	
func kill():
	die.emit(self)
	self.queue_free()
