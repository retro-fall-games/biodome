class_name MoveState
extends BaseState

@export var move_speed: float = 60
@export var jump_node: NodePath
@export var jump_flip_node: NodePath
@export var fall_node: NodePath
@export var dash_node: NodePath
@export var idle_node: NodePath
@export var walk_node: NodePath
@export var run_node: NodePath

@onready var jump_state: BaseState = get_node(jump_node)
@onready var jump_flip_state: BaseState = get_node(jump_flip_node)
@onready var fall_state: BaseState = get_node(fall_node)
@onready var idle_state: BaseState = get_node(idle_node)
@onready var dash_state: BaseState = get_node(dash_node)
@onready var walk_state: BaseState = get_node(walk_node)
@onready var run_state: BaseState = get_node(run_node)

const FLOOR_NORMAL = Vector2.UP
const SNAP_DIRECTION = Vector2.DOWN
const SNAP_LENGTH = 32

var snap_vector = SNAP_DIRECTION * SNAP_LENGTH

func input(event: InputEvent) -> BaseState:
	if Input.is_action_just_pressed("jump"):
		return jump_state
	
	if Input.is_action_just_pressed("dash"):
		return dash_state

	return null

func physics_process(delta: float) -> BaseState:
	if !player.is_on_floor():
		return fall_state

	var move = get_movement_input()
	#if move < 0:
	#	player.sprite.flip_h = true
	#elif move > 0:
	#	player.sprite.flip_h = false
	
	player.velocity.y += player.gravity
	player.velocity.x = move * move_speed
	player.move_and_slide()
	player.flip()

	if move == 0:
		return idle_state
	else:
		if player.is_going_down_slope():
			print("Down Slope")
		elif player.is_going_up_slope():
			print("Up Slope")
	

	return null

func get_movement_input() -> int:
	if Input.is_action_pressed("left"):
		return -1
	elif Input.is_action_pressed("right"):
		return 1
	
	return 0
