extends Area2D

@export var scene : String
@export var mask : String
@export var id : int = 0
@export var goto_id : int = 0

func _on_scene_door_body_entered(body):
	if body.name == mask:
		Global.goto_scene(scene)
