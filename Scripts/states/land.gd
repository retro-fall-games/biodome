extends BaseState

@export var land_time: float = 0.5

@export var jump_node : NodePath 
@export var fall_node : NodePath 
@export var walk_node : NodePath 
@export var run_node : NodePath 
@export var dash_node : NodePath 
@export var idle_node: NodePath

@onready var jump_state: BaseState = get_node(jump_node)
@onready var fall_state: BaseState = get_node(fall_node)
@onready var walk_state: BaseState = get_node(walk_node)
@onready var run_state: BaseState = get_node(run_node)
@onready var dash_state: BaseState = get_node(dash_node)
@onready var idle_state: BaseState = get_node(idle_node)

var _time = 0

func enter() -> void:
	# This calls the base class enter function, which is necessary here
	# to make sure the animation switches
	super.enter()
	_time = 0
	
func input(event: InputEvent) -> BaseState:
	if Input.is_action_just_pressed("left") or Input.is_action_just_pressed("right"):
		if Input.is_action_pressed("run"):
			return run_state
		return walk_state
	elif Input.is_action_just_pressed("jump"):
		return jump_state
	elif Input.is_action_just_pressed("dash"):
		return dash_state
	return null

func physics_process(delta: float) -> BaseState:
	if _process_timer(delta):
		return idle_state
		
	player.velocity.y += player.gravity
	player.move_and_slide()
	if not player.is_on_floor():
		return fall_state
		
	return null

func _process_timer(delta) -> bool:
	_time += delta
	if _time > land_time:
		_time = 0
		return true
	return false
