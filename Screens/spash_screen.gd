extends Node2D

@export var scene : String

func _input(event):
	if (event is InputEventKey):
		Global.goto_scene(scene)

func _on_animation_player_animation_finished(anim_name):
	Global.goto_scene(scene)
