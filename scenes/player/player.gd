class_name Player
extends CharacterBody2D

var holding: ThrowableBody = null

func can_pick_up():
	return holding == null
	
func release():
	holding = null
	
func pick_up(body: ThrowableBody): 
	holding = body
