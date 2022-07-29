extends Area2D

@export var scene : PackedScene

func _on_scene_door_body_entered(body):
	Global.goto_scene(scene)
