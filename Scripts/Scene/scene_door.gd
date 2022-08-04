extends Area2D

@export var scene : String

func _on_scene_door_body_entered(body):
	if body.name == "Player":
		Global.goto_scene(scene)
