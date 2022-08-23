extends Control
class_name Dialog

@onready var label = $MarginContainer/MarginContainer/Label

func _ready():
	label.visible = false
	
func get_class():
	return "Dialog"

func is_class(value):
	if value == "Dialog":
		return true
	else:
		return false
		
func _input(event):
	if event is InputEventKey and event.is_pressed():
		if event.keycode == KEY_ENTER:
			if label.visible:
				await get_tree().create_timer(.01).timeout 
				label.visible = false

func set_text(text : String):
	label.text = text
	label.visible = true
	
func is_showing():
	return label.visible == true
