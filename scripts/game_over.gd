extends Control

@onready var game_over_label = $TextureRect/Label
@onready var node_2d_2 = $"../.."

func _ready():
	#self.visible = false
	Global.game_over.connect(on_game_over)
	
func on_game_over(value):
	if value:
		game_over_label.text = "YOU WIN!"
	else:
		game_over_label.text = "GAME OVER!"
		
	get_tree().paused = true
	self.visible = true


func _on_play_again_button_button_down():
	Global.has_reloaded = true
	Global.tutorial = false
	get_tree().reload_current_scene()
	pass # Replace with function body.


func _on_exit_button_button_down():
	get_tree().quit()
	pass # Replace with function body.
