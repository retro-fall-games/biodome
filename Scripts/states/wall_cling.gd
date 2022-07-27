extends BaseState

@export var move_speed: float = 60
@export var fall_node: NodePath
@export var wall_jump_node: NodePath

@onready var fall_state: BaseState = get_node(fall_node)
@onready var wall_jump_state: BaseState = get_node(wall_jump_node)

func physics_process(delta: float) -> BaseState:
	var move = 0
	if Input.is_action_pressed("left"):
		move = -1
		player.sprite.flip_h = true
	elif Input.is_action_pressed("right"):
		move = 1
		player.sprite.flip_h = false
		
	player.velocity.x = move * move_speed	
	player.velocity.y = 0
	player.move_and_slide()
	
	if Input.is_action_just_pressed("jump"):
		return wall_jump_state
		
	if not player.is_on_wall():
		return fall_state
		
	return null
