extends CanvasLayer

@onready var play_button = $MainMenu
@onready var tool_tip = $ToolTip

func _ready():
	Global.game_start.connect(_start)
	Global.tutorial_start.connect(_tutorial)

func _start() -> void:
	for child in get_children():
		child.show()
	play_button.hide()
	tool_tip.hide()
	
func _tutorial() -> void:
	play_button.hide()
	pass
