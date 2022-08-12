extends Control

@export var save_name : String = "Save"

# Called when the node enters the scene tree for the first time.
func _ready():
	$HBoxContainer/Name.text = save_name

func _on_start_button_pressed():
	print("start")
