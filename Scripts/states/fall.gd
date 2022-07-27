extends BaseState

@export var move_speed: float = 60
@export var run_node: NodePath
@export var walk_node: NodePath
@export var idle_node: NodePath
@export var land_node: NodePath
@export var wall_cling_node: NodePath

@onready var run_state: BaseState = get_node(run_node)
@onready var walk_state: BaseState = get_node(walk_node)
@onready var idle_state: BaseState = get_node(idle_node)
@onready var land_state: BaseState = get_node(land_node)
@onready var wall_cling_state: BaseState = get_node(wall_cling_node)

func physics_process(delta: float) -> BaseState:
	var move = 0
	if Input.is_action_pressed("left"):
		move = -1
		player.sprite.flip_h = true
	elif Input.is_action_pressed("right"):
		move = 1
		player.sprite.flip_h = false
	
	player.velocity.x = move * move_speed
	player.velocity.y += player.gravity
	player.move_and_slide()
	
	if player.is_on_wall():
		return wall_cling_state

	if player.is_on_floor():
		if move != 0:
			if Input.is_action_pressed("run"):
				return run_state
			return walk_state
		else:
			return land_state
	return null
