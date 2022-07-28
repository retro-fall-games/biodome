extends MoveState

@export var land_node: NodePath

@onready var land_state: BaseState = get_node(land_node)

func physics_process(delta: float) -> BaseState:
	
	# Handle character movement
	move()
	
	# Handle if they land on a wall
	if character.is_on_wall():
		return wall_cling_state

	# Handle if they touch the floor, if there is no movement then transition to a land state
	# if they do have movement transition to run or walk
	if character.is_on_floor():
		if movement_input != 0:
			if Input.is_action_pressed("run"):
				return run_state
			return walk_state
		else:
			return land_state
			
	# Default State
	return null
