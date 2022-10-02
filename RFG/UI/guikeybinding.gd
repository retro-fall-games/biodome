extends CanvasLayer

@export var back_scene : String

var file_name = "res://keybinding.json"

var key_dict = {
	"jump": KEY_SPACE,
	"left": KEY_A,
	"right": KEY_D,
	"up": KEY_W,
	"down": KEY_S
}
				
var setting_key = false
var overlay

func _ready():
	overlay = $Overlay
	if overlay:
		overlay.visible = false
	load_keys()
	
func load_keys():
	if FileAccess.file_exists(file_name):
		delete_old_keys()
		var file = FileAccess.open(file_name, FileAccess.READ)
		var json = JSON.new()
		var json_string = file.get_as_text();
		var error = json.parse(json_string)
		var data
		if error == OK:
			data = json.get_data()
			if typeof(data) == TYPE_DICTIONARY:
				key_dict = data
				setup_keys()
			else:
				print("Unexpected data")
		else:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
	else:
		#NoFile, so lets save the default keys now
		save_keys()
	pass
	
func delete_old_keys():
	#Remove the old keys
	for i in key_dict:
		var oldkey = InputEventKey.new()
#		oldkey.keycode = int(Guikeybinding.key_dict[i])
		InputMap.action_erase_event(i,oldkey)

func setup_keys():
	for i in key_dict:
		for j in get_tree().get_nodes_in_group("button_keys"):
			if(j.action_name == i):
				j.text = OS.get_keycode_string(key_dict[i])
		var newkey = InputEventKey.new()
		newkey.keycode = int(key_dict[i])
		InputMap.action_add_event(i,newkey)
	
func save_keys():
	var file = FileAccess.open(file_name, FileAccess.WRITE)
	var json_object = JSON.new()
	print(json_object.stringify(key_dict))
	file.store_string(json_object.stringify(key_dict))
	file.close()
	print("saved")
	pass


func _on_button_pressed():
	Global.goto_scene(back_scene)

func show_overlay(show):
	if overlay:
		overlay.visible = show
