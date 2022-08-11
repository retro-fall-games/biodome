extends Control

@export var back_scene_path: String

var music_bus_index
var ambience_bus_index
var fx_bus_index

var save_path = "res://save-file.cfg"
var config = ConfigFile.new()
var load_response = config.load(save_path)

func _ready():
	# Set Music Volume
	music_bus_index = AudioServer.get_bus_index("Music")
	var music_volume = config.get_value("Audio", "Music", 1)
	$VBoxContainer/MusicSlider.value = music_volume
	set_bus_volume("Music", music_volume)
	
	# Set Ambience Volume
	ambience_bus_index = AudioServer.get_bus_index("Ambience")
	var ambience_volume = config.get_value("Audio", "Ambience", 1)
	$VBoxContainer/AmbienceSlider.value = ambience_volume
	set_bus_volume("Ambience", ambience_volume)
	
	# Set FX Volume
	fx_bus_index = AudioServer.get_bus_index("FX")
	var fx_volume = config.get_value("Audio", "FX", 1)
	$VBoxContainer/FXSlider.value = fx_volume
	set_bus_volume("FX", fx_volume)

func _on_back_button_pressed():
	Global.goto_scene(back_scene_path)

func set_bus_volume(name: String, value: float):
	var bus_index = AudioServer.get_bus_index(name)
	print(bus_index)
	if value == -45:
		AudioServer.set_bus_mute(bus_index, true)
	else:
		AudioServer.set_bus_volume_db(bus_index, linear2db(value))
		AudioServer.set_bus_mute(bus_index, false)
		
	config.set_value("Audio", name, value)
	config.save(save_path)

func _on_music_slider_value_changed(value):
	set_bus_volume("Music", value)
	
func _on_ambience_slider_value_changed(value):
	set_bus_volume("Ambience", value)
	
func _on_fx_slider_value_changed(value):
	set_bus_volume("FX", value)
