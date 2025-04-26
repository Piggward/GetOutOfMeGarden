extends Node2D

@onready var flowers = [
	$Flower,
	$Flower2,
	$Flower3,
	$Flower4,
	$Flower5
]
var flower_start_frames = [0, 10, 20, 30, 40, 50, 60, 70, 80]
func _ready() -> void:
	for flower in flowers:
		var random_frame = randi_range(0, flower_start_frames.size() - 1)
		flower.set_sprite_start_id(flower_start_frames.pop_at(random_frame))
