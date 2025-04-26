extends Node2D
class_name FlowerBed
@onready var flowers = [
	$Flower,
	$Flower2,
	$Flower3,
	$Flower4,
	$Flower5
]
var flower_start_frames = [0, 1, 2, 3, 4, 5, 6, 7, 8]

func _ready() -> void:
	for flower in flowers:
		var random_frame = randi_range(0, flower_start_frames.size() - 1)
		flower.start_sprite_id = flower_start_frames.pop_at(random_frame*6)

func set_growth_stage(id: int):
	for flower in flowers:
		flower.set_growth_stage(id)
		
func get_random_alive_flower()-> Area2D:
	return flowers[randi_range(0,flowers.size()-1)]
	
