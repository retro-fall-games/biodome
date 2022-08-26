class_name Spawn
extends Area2D

@export var mask : String

func _on_spawn_body_entered(body):
	if body.name == mask:
		Global.update_spawn(self.global_position)
