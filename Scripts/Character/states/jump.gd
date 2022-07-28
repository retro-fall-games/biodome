class_name JumpState
extends MoveState

@export var jump_force: float = 100
@export var double_jump: bool = true

var jump_count = 0

func enter() -> void:
	# This calls the base class enter function, which is necessary here
	# to make sure the animation switches
	super.enter()
	character.set_force_y(-jump_force)
	
func physics_process(delta: float) -> BaseState:
	# Handle character movement
	move()
	
	# Handle Double Jump
	if double_jump and jump_count == 0 and Input.is_action_just_pressed("jump"):
		jump_count += 1
		super.enter()
		character.set_force_y(-jump_force)
		return null
	
	# Handle when to transition to a fall state
	if character.velocity.y > 0:
		return fall_state
		
	# Handle if they land on a wall
	if character.is_on_wall():
		jump_count = 0
		return wall_cling_state

	# Handle when they finally touch the floor
	if character.is_on_floor():
		jump_count = 0
		if movement_input != 0:
			if Input.is_action_pressed("run"):
				return run_state
			return walk_state
		return idle_state
		
	# Default State
	return null
