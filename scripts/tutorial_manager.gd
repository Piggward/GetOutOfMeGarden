extends Node

const SCISSORS = preload("res://scenes/tools/scissors.tscn")
@onready var scissor_marker = $"../Boundries/ToolArea/ScissorMarker"
@onready var first_weed_marker = $FirstWeedMarker
@onready var tool_tip = $"../CanvasLayer/ToolTip"
@onready var tool_label = $"../CanvasLayer/ToolTip/Label"
var interacted: Array[String] = []
@onready var overgrowth_bar = $"../CanvasLayer/OvergrowthBar"
const BUNNY = preload("res://scenes/bunny.tscn")
@onready var first_bunny_marker = $FirstBunnyMarker
const SHOVEL = preload("res://scenes/tools/shovel.tscn")
const WEED = preload("res://scenes/weed.tscn")
@onready var shovel_marker = $"../Boundries/ToolArea/ShovelMarker"
const ROOT = preload("res://scenes/root.tscn")
@onready var first_stump_marker = $FirstStumpMarker

func _ready():
	Global.has_interacted.connect(_on_first_interact)
	Global.has_picked_up.connect(_on_first_pick_up)
	tool_tip.visible = true
	tool_label.text = "Welcome to your garden! Pick up the Watering Can using right click to prepare for your day."
	
func _on_first_interact(area: InteractableArea):
	if area is Flower and not interacted.has("flower"):
		interacted.append("flower")
		print("flower")
		tool_label.text = "Wow you are a gardening genius!"
		await get_tree().create_timer(2).timeout
		tool_label.text = "But watch out! Your garden is host to vicious weeds"
		overgrowth_bar.visible = true
		var weed = WEED.instantiate()
		get_tree().root.add_child(weed)
		weed.global_position = first_weed_marker.global_position
		await get_tree().create_timer(3.5).timeout
		tool_label.text = "If you let too many grow, your garden will be overgrown!"
		await get_tree().create_timer(3).timeout
		var scissor = SCISSORS.instantiate()
		get_tree().root.add_child(scissor)
		scissor.global_position = scissor_marker.global_position
		tool_label.text = "Pick up the scissors to take out the weed."
		await weed.die
		tool_label.text = "Outstanding! You are a god!"
		await get_tree().create_timer(2).timeout
		var bunny = BUNNY.instantiate()
		bunny.global_position = first_bunny_marker.global_position
		get_tree().root.add_child(bunny)
		tool_label.text = "Seems you have gotten yourself a cute friend, but dont be fooled!"
		await get_tree().create_timer(3).timeout
		tool_label.text = "That rabbit is after your flowers which is also your LIFE!"
		await get_tree().create_timer(3).timeout
		tool_label.text = "Take that rabbit and throw it out of here!"

func _on_first_pick_up(object: ThrowableBody):
	if object is WateringCan and not interacted.has("watering_can"):
		interacted.append("watering_can")
		tool_label.text = "Good job! Now use left click to water your precious flowers."
	if object is Bunny and not interacted.has("bunny"):
		interacted.append("bunny")
		tool_label.text = "Good riddance! No matter how cute it is, dont let it get to your flowers!"
		await get_tree().create_timer(3).timeout
		tool_label.text = "Now, pick up the shovel to remove the tree stump."
		var shovel = SHOVEL.instantiate()
		shovel.global_position = shovel_marker.global_position
		get_tree().root.add_child(shovel)
		var stump = ROOT.instantiate()
		stump.global_position = first_stump_marker.global_position
		get_tree().root.add_child(stump)
		await stump.die
		tool_label.text = "Great, you are now on your own, see you bye bye"
		await get_tree().create_timer(4).timeout
		Global.tutorial = false
		tool_tip.visible = false
	pass
