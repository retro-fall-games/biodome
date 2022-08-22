extends Node

@onready var text_prompt = $TextPrompt
@onready var text = $TextPrompt/MarginContainer/MarginContainer/HBoxContainer/TextEdit

func _ready():
	text_prompt.visible = false

func _input(event):
	if event is InputEventKey and event.is_pressed():
		if event.keycode == KEY_ENTER:
			if text_prompt.visible:
				process_command(text.text)
				text_prompt.visible = false
				get_tree().paused = false
			else:
				text_prompt.visible = true
				text.grab_focus()
				get_tree().paused = true
			await get_tree().create_timer(.01).timeout 
			text.text = ""

func process_command(command: String):
	command = command.strip_edges(true, true)
	print("You have entered the command: ", command)
