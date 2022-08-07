extends Control

@export var audio_scene : String
@export var controls_scene : String
@export var back_scene : String

# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/AudioButton.grab_focus()

func _on_audio_button_pressed():
	Global.goto_scene(audio_scene)

func _on_controls_button_pressed():
	Global.goto_scene(controls_scene)

func _on_back_button_pressed():
	Global.goto_scene(back_scene)
