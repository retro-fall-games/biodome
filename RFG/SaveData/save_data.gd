extends Node

func save():
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for i in save_nodes:
		# Now, we can call our save function on each node.
		pass
		
		
# Note: This can be called from anywhere inside the tree. This function is
# path independent.
# Go through everything in the persist category and ask them to return a
# dict of relevant variables.
func save_game():
	var save_game = File.new()
	save_game.open("user://savegame.save", File.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for node in save_nodes:
		# Check the node is an instanced scene so it can be instanced again during load.
		if node.filename.empty():
			print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			continue

		# Check the node has a save function.
		if !node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue

		# Call the node's save function.
		var node_data = node.call("save")

		# Store the save dictionary as a new line in the save file.
		var json_object = JSON.new()
		save_game.store_line(json_object.stringify(node_data))
		
	save_game.close()
	
# Note: This can be called from anywhere inside the tree. This function
# is path independent.
func load_game():
	var save_game = File.new()
	if not save_game.file_exists("user://savegame.save"):
		return # Error! We don't have a save to load.

	# We need to revert the game state so we're not cloning objects
	# during loading. This will vary wildly depending on the needs of a
	# project, so take care with this step.
	# For our example, we will accomplish this by deleting saveable objects.
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for i in save_nodes:
		i.queue_free()

	# Load the file line by line and process that dictionary to restore
	# the object it represents.
	save_game.open("user://savegame.save", File.READ)
	while save_game.get_position() < save_game.get_len():
		var json = JSON.new()
		# Get the saved dictionary from the next line in the save file
		var node_data = json.parse(save_game.get_line())

		var filename = node_data.get("filename")
		# Firstly, we need to create the object and add it to the tree and set its position.
		var new_object = load(filename).instance()
		get_node(node_data.get("parent")).add_child(new_object)
		new_object.position = Vector2(node_data.get("pos_x"), node_data.get("pos_y"))

		# Now we set the remaining variables.
		for i in node_data.keys():
			if i == "filename" or i == "parent" or i == "pos_x" or i == "pos_y":
				continue
			new_object.set(i, node_data.get(i))

	save_game.close()
