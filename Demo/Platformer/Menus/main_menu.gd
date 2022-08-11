extends Control

@export var start_scene_path: String
@export var options_scene_path: String

# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/StartButton.grab_focus()

func _on_start_button_pressed():
	$TransitionScreen.fade_out()

func _on_options_button_pressed():
	Global.goto_scene(options_scene_path)

func _on_quit_button_pressed():
	get_tree().quit()

func _on_transition_screen_fade_in_finished():
	pass # Replace with function body.

func _on_transition_screen_fade_out_finished():
	Global.goto_scene(start_scene_path)
