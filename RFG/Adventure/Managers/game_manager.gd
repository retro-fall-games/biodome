extends Node

var file_name = "user://game_world.dat"
var spawn_at : RoomSpawnAt
var world_data = {}

func _ready():
	print("load game manager")

func get_world_data():
	return world_data

func save_world_data(new_world_data):
	world_data.merge(new_world_data, true)
	var file = FileAccess.open(file_name, FileAccess.WRITE)
	var json_object = JSON.new()
	file.store_line(json_object.stringify(world_data))

func load_world_data():
	if not FileAccess.file_exists(file_name):
		return
	var file = FileAccess.open(file_name, FileAccess.READ)
	var content = file.get_as_text()
	var json = JSON.new()
	# Get the saved dictionary from the next line in the save file
	var error = json.parse(content)

	if error == OK:
		world_data = json.get_data()
	else:
		print("JSON Parse Error: ", json.get_error_message(), " in ", content, " at line ", json.get_error_line())
