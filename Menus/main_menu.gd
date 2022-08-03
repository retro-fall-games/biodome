extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/StartButton.grab_focus()

func _on_start_button_pressed():
	print("Start")
	# get_tree().change_scene()


func _on_options_button_pressed():
	print("Options")


func _on_quit_button_pressed():
	get_tree().quit()
