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
@onready var pointer = $Pointer
@onready var watering_can = $"../WateringCan"
@onready var flower_bed = $"../FlowerBed"
var flowers: Array[Area2D] = []
@onready var bunny_throw_marker = $"Bunny Throw Marker"
@onready var next_rect = $"../CanvasLayer/ToolTip/NextRect"
@onready var animation_player = $AnimationPlayer

@export var show_tutorial: bool = true

func _ready():
	Global.tutorial_start.connect(start)

func start():
	if not show_tutorial:
		await get_parent().ready
		var s = SHOVEL.instantiate()
		var ss = SCISSORS.instantiate()
		get_parent().add_child(s)
		get_parent().add_child(ss)
		s.global_position = shovel_marker.global_position
		ss.global_position = scissor_marker.global_position
		tutorial_finished()
		return
	Global.has_interacted.connect(_on_first_interact)
	Global.has_picked_up.connect(_on_first_pick_up)
	tool_tip.visible = true
	tool_label.text = "Welcome to your garden! Pick up the Watering Can using right click to prepare for your day."
	pointer.global_position = watering_can.global_position + Vector2(0, -30)
	pointer.visible = true
	next_rect.visible = false
	animation_player.play("tutorial")
	
func tutorial_finished():
	Global.tutorial = false
	Global.game_start.emit()
	tool_tip.visible = false
	pointer.queue_free()
	animation_player.play_backwards("tutorial")
	
func _on_first_interact(area: InteractableArea):
	if area is Flower and not interacted.has("flower"):
		if flowers.any(func(a): return a.has_pointer):
			return
		interacted.append("flower")
		flowers = []
		print("flower")
		tool_label.text = "Wow you are a gardening genius!"
		next_rect.visible = true
		await next_rect.next_pressed
		tool_label.text = "But watch out! Your garden is host to vicious weeds"
		overgrowth_bar.visible = true
		var weed = WEED.instantiate()
		get_tree().root.add_child(weed)
		weed.global_position = first_weed_marker.global_position
		await next_rect.next_pressed
		tool_label.text = "If you let too many grow, your garden will be overgrown!"
		await next_rect.next_pressed
		var scissor = SCISSORS.instantiate()
		get_tree().root.add_child(scissor)
		scissor.global_position = scissor_marker.global_position
		tool_label.text = "Pick up the scissors to take out the weed."
		next_rect.visible = false
		pointer.visible = true
		pointer.global_position = scissor.global_position + Vector2(0, -30)
		await weed.die
		tool_label.text = "Outstanding! You are a god!"
		pointer.visible = false
		next_rect.visible = true
		await next_rect.next_pressed
		var bunny = BUNNY.instantiate()
		bunny.global_position = first_bunny_marker.global_position
		get_tree().root.add_child(bunny)
		pointer.global_position = bunny.global_position
		pointer.reparent(bunny)
		pointer.visible = true
		tool_label.text = "That rabbit is after your flowers which is also your LIFE! Pick it up with right click!"
		next_rect.visible = false
	elif area is Flower and interacted.has("waiting_second_flower"):
		if flowers.any(func(a): return a.has_pointer):
			return
		interacted.erase("waiting_second_flower")
		tool_label.text = "Great! Keep your flowers healthy. They are literally your life."
		next_rect.visible = true
		await next_rect.next_pressed
		tool_label.text = "Now, pick up the shovel to remove the tree stump."
		next_rect.visible = false
		var shovel = SHOVEL.instantiate()
		shovel.global_position = shovel_marker.global_position
		get_tree().root.add_child(shovel)
		pointer.reparent(self)
		pointer.visible = true
		pointer.global_position = shovel.global_position + Vector2(0, -30)
		var stump = ROOT.instantiate()
		stump.global_position = first_stump_marker.global_position
		get_tree().root.add_child(stump)
		await stump.die
		tool_label.text = "Great, you are now on your own, good luck!"
		next_rect.visible = true
		next_rect.get_child(0).text = "Begin!"
		await next_rect.next_pressed
		Global.tutorial = false
		Global.game_start.emit()
		tool_tip.visible = false
		pointer.queue_free()
		animation_player.play_backwards("tutorial")

func _on_first_pick_up(object: ThrowableBody):
	if object is WateringCan and not interacted.has("watering_can"):
		interacted.append("watering_can")
		tool_label.text = "Good job! Now use left click to water your precious flowers."
		for child in flower_bed.get_children():
			var p = pointer.duplicate(true)
			p.position = Vector2(0, -30)
			child.add_child(p)
			child.has_pointer = true
			flowers.append(child)
		pointer.visible = false
	elif object is Bunny and not interacted.has("bunny"):
		interacted.append("bunny")
		pointer.throw()
		pointer.global_position = bunny_throw_marker.global_position
		tool_label.text = "Throw that bunny out of here!"
		await get_tree().create_timer(3).timeout
		tool_label.text = "Good riddance! No matter how cute it is, dont let it get to your flowers!"
		next_rect.visible = true
		await next_rect.next_pressed
		tool_label.text = "Dont forget to water your flowers again! Find your watering can and water them."
		next_rect.visible = false
		pointer.reparent(self)
		pointer.visible = true
		pointer.global_position = watering_can.global_position + Vector2(0, -30)
		pointer.bob()
		interacted.append("waiting_second_watering_can")
	elif object is Scissors and not interacted.has("scissors"):
		interacted.append("scissors")
		tool_label.text = "Left click with the scissors to take out the weed."
		pointer.global_position = first_weed_marker.global_position + Vector2(0, -30)
	elif object is Shovel and not interacted.has("shovel"):
		interacted.append("shovel")
		tool_label.text = "Left click with the shovel to remove the tree stump."
		pointer.global_position = first_stump_marker.global_position + Vector2(0, -30)
	elif object is WateringCan and interacted.has("waiting_second_watering_can"):
		interacted.erase("waiting_second_watering_can")
		interacted.append("waiting_second_flower")
		for child in flower_bed.get_children():
			child.set_to_low()
			var p = pointer.duplicate(true)
			p.position = Vector2(0, -30)
			child.add_child(p)
			child.has_pointer = true
			child.set_to_low()
			flowers.append(child)
		pointer.visible = false
	pass
