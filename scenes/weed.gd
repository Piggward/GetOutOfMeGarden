extends Area2D

func _ready():
	connect("mouse_entered", _on_mouse_entered)
	connect("mouse_exited", _on_mouse_exited)
	
func _on_mouse_entered():
	print("touched some grass")
	
func _on_mouse_exited():
	print("stopped touching grass, fkn weeb")
