extends Node
class_name Dialog

@onready var label = $MarginContainer/MarginContainer/Label

var hotspots : Array
var message_queue : Array

func _ready():
	label.visible = false
	var owner = get_owner()
	if !owner:
		owner = self
	find_hotspots(owner, hotspots)
	var callable = Callable(self, '_on_dialog_message')
	for hotspot in hotspots:
		hotspot.connect("on_dialog_message", callable)
	
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
				if message_queue.size() == 0:
					get_tree().paused = false
				
func _physics_process(delta):
	if message_queue.size() > 0:
		run_queue()
		
func set_text(text : String):
	label.text = text
	label.visible = true
	
func is_showing():
	return label.visible == true
	
func hide():
	label.visible = false
	
func find_hotspots(node: Node, result : Array) -> void:
	if node is Hotspot:
		result.push_back(node)
	for child in node.get_children():
		find_hotspots(child, result)
		
func _on_dialog_message(message):
	if message is String:
		message_queue.push_back(message)
		
func send_message(message):
	if message is String:
		message_queue.push_back(message)

func run_queue():
	if is_showing():
		return
	var next = message_queue.pop_front()
	set_text(next)
	await get_tree().create_timer(1).timeout 
