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
@export var wall_cling_node: NodePath
@export var wall_jump_node: NodePath

@onready var jump_state: BaseState = get_node(jump_node)
@onready var jump_flip_state: BaseState = get_node(jump_flip_node)
@onready var fall_state: BaseState = get_node(fall_node)
@onready var idle_state: BaseState = get_node(idle_node)
@onready var dash_state: BaseState = get_node(dash_node)
@onready var walk_state: BaseState = get_node(walk_node)
@onready var run_state: BaseState = get_node(run_node)
@onready var wall_cling_state: BaseState = get_node(wall_cling_node)
@onready var wall_jump_state: BaseState = get_node(wall_jump_node)

var movement_input = 0

func input(event: InputEvent) -> BaseState:
	if Input.is_action_just_pressed("jump"):
		return jump_state
	if Input.is_action_just_pressed("dash"):
		return dash_state
	return null

func physics_process(delta: float) -> BaseState:
	if !character.is_on_floor():
		return fall_state

	move()

	if movement_input == 0:
		return idle_state
	else:
		if character.is_going_down_slope():
			print("Down Slope")
		elif character.is_going_up_slope():
			print("Up Slope")
			
	return null

func get_movement_input() -> int:
	if Input.is_action_pressed("left"):
		return -1
	elif Input.is_action_pressed("right"):
		return 1
	return 0
	
func move():
	movement_input = get_movement_input()	
	character.apply_gravity()
	character.set_force_x(movement_input * move_speed)
	character.move()
	
func move_snap():
	movement_input = get_movement_input()	
	character.apply_gravity()
	character.set_force_x(movement_input * move_speed)
	character.move_snap()
