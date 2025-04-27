extends Node2D

@onready var fish_anim = $FishAnim
@onready var spawn_point = $SpawnPoint
var fish_scene = preload("res://scenes/fish/fish.tscn")
@export var spawn_paths: Array[Path2D] = []

func start_fish_spawn_timer(seconds: int):
	$Timer.start(seconds)

func spawn_fish():
	fish_anim.play("hook")
	var fish = fish_scene.instantiate()
	var random_path = randi_range(0, spawn_paths.size()-1)

	fish.spawn(spawn_paths[random_path].get_child(0))
	spawn_paths[random_path].get_child(0).add_child(fish)
	fish.position = Vector2.ZERO


func _on_fish_anim_animation_finished() -> void:
	if fish_anim.animation == "hook":
		fish_anim.play("throw")
	elif fish_anim.animation == "throw":
		fish_anim.play("default")
	


func _on_timer_timeout() -> void:
	spawn_fish()
