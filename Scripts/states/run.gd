extends MoveState

func input(event: InputEvent) -> BaseState:
	if Input.is_action_just_pressed("jump"):
		return jump_flip_state
	
	if Input.is_action_just_pressed("dash"):
		return dash_state
	
	if Input.is_action_just_released("run"):
		return walk_state

	return null
