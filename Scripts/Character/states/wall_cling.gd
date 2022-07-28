extends MoveState

@export var gravity_multiplier = .5

func enter() -> void:
	super.enter()
	# Affect Gravity
	character.gravity *= gravity_multiplier;

func input(event: InputEvent) -> BaseState:
	if Input.is_action_just_pressed("jump"):
		return wall_jump_state
	
	return null

func physics_process(delta: float) -> BaseState:
	# Handle Move character
	move()
	
	# Handle falling off the wall
	if not character.is_on_wall():
		return fall_state
		
	# Default State
	return null
	
func exit() -> void:
	super.exit()
	character.reset_gravity()
