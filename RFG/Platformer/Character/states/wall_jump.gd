extends JumpState

func enter() -> void:
	# This calls the base class enter function, which is necessary here
	# to make sure the animation switches
	super.enter()
	character.set_force_y(-jump_force)
	character.set_force_x(move_speed)
