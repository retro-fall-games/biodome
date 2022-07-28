class_name BaseState
extends Node

@export var animation_name: String

# Pass in a reference to the character's kinematic body so that it can be used by the state
var character: Character

func enter() -> void:
	character.animation_player.play(animation_name)
	
func exit() -> void:
	pass

func input(event: InputEvent) -> BaseState:
	return null

func process(delta: float) -> BaseState:
	return null

func physics_process(delta: float) -> BaseState:
	return null
