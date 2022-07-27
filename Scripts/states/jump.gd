extends BaseState

@export var jump_force: float = 100
@export var move_speed: float = 60
@export var double_jump: bool = true
@export var fall_node: NodePath
@export var run_node: NodePath
@export var walk_node: NodePath
@export var idle_node: NodePath
@export var wall_cling_node: NodePath

@onready var fall_state: BaseState = get_node(fall_node)
@onready var run_state: BaseState = get_node(run_node)
@onready var walk_state: BaseState = get_node(walk_node)
@onready var idle_state: BaseState = get_node(idle_node)
@onready var wall_cling_state: BaseState = get_node(wall_cling_node)

var jump_count = 0

func enter() -> void:
	# This calls the base class enter function, which is necessary here
	# to make sure the animation switches
	super.enter()
	player.velocity.y = -jump_force

func physics_process(delta: float) -> BaseState:
	var move = 0
	if Input.is_action_pressed("left"):
		move = -1
		player.sprite.flip_h = true
	elif Input.is_action_pressed("right"):
		move = 1
		player.sprite.flip_h = false
		
	if double_jump and jump_count == 0 and Input.is_action_just_pressed("jump"):
		jump_count += 1
		return self
	
	player.velocity.x = move * move_speed
	player.velocity.y += player.gravity
	player.move_and_slide()
	
	if player.velocity.y > 0:
		return fall_state
		
	if player.is_on_wall():
		jump_count = 0
		return wall_cling_state

	if player.is_on_floor():
		jump_count = 0
		if move != 0:
			if Input.is_action_pressed("run"):
				return run_state
			return walk_state
		return idle_state
	return null