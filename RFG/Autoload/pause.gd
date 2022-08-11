extends CanvasLayer

@export var fullscreen = false

# Called when the node enters the scene tree for the first time.
func _ready():
	set_visible(false)
	# if fullscreen:
	#	set_fullscreen(true)

func _input(event):
	if event.is_action_pressed("pause"):
		set_visible(!get_tree().paused)
		get_tree().paused = !get_tree().paused

func _on_continue_pressed():
	get_tree().paused = false
	set_visible(false)
	
func _on_quit_pressed():
	get_tree().quit()

func set_visible(is_visible):
	for node in get_children():
		node.visible = is_visible

func _on_fullscreen_pressed():
	set_fullscreen(!fullscreen)

func set_fullscreen(_fullscreen):
	if _fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	fullscreen = _fullscreen
