class_name RoomDoor
extends Area2D

@export var scene : String
@export var id : int = 0
@export var goto_id : int = 0
@export var movement_direction : AdventureCharacter.MovementDirection

var room_spawn_at : RoomSpawnAt

var file_name = "user://roomdoor.dat"

signal spawn_player(new_position, move_direction)

func _ready():
	GlobalSignals.add_emitter('spawn_player', self)
	for child in get_children():
		if child is RoomSpawnAt:
			room_spawn_at = child	
	if room_spawn_at == null:
		print("No room spawn at postion: ", name)
	var world_data = GameManager.get_world_data();
	if world_data.has("goto_id") and world_data.get("goto_id") == id:
		GlobalSignals.emit_signal_when_ready('spawn_player', [position + room_spawn_at.position, movement_direction], self)
			
func _on_room_door_body_entered(_body):
	var new_world_data = {
		"from_scene_path" : get_tree().current_scene.scene_file_path,
		"from_id" : id,
		"goto_id" : goto_id
	}
	GameManager.save_world_data(new_world_data) 
	get_tree().change_scene_to_file(scene)
