extends AnimatedSprite2D
@onready var animated_sprite_2d: AnimatedSprite2D = $"."

func _ready():
	animated_sprite_2d.play("animation_1")
