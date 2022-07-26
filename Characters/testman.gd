extends CharacterBody2D

@export var move_speed : float = 100
@export var jump_velocity : float = -400
@export var starting_direction : Vector2 = Vector2(0, 1)
@export var max_velocity : Vector2 = Vector2(500, 500)
@export var time_to_run : float = 2
@export var run_multiplier : float = 2
@export var wall_jump_horizontal: float = 200

var _duration_pressed = 0
var _is_running = false
var _is_jumping = false
var _is_falling = false

@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback");
@onready var sprite = $Sprite2D

# Get the gravity from the project settings to be synced with RigidDynamicBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	animation_tree.set("parameters/Run/blend_position", starting_direction)
	animation_tree.set("parameters/Walk/blend_position", starting_direction)
	animation_tree.set("parameters/Idle/blend_position", starting_direction)

func _physics_process(delta):
		
	_is_running = false
		
	# Handle flips, button duration, and is running
	if Input.is_action_pressed("left"):
		
		# If we were facing right and now we are pushing left
		if sprite.flip_h == false:
			_duration_pressed = 0
		elif _duration_pressed > time_to_run:
			_is_running = true
			
		sprite.flip_h = true
		_duration_pressed += delta	
		
	if Input.is_action_pressed("right"):
		
		# If we were facing left and now we are pushing right
		if sprite.flip_h == true:
			_duration_pressed = 0
		elif _duration_pressed > time_to_run:
			_is_running = true
			
		sprite.flip_h = false
		_duration_pressed += delta	
	
	var is_on_floor = is_on_floor()
	
	# Handle Jump.
	var is_jump_pressed = Input.is_action_just_pressed("jump");
	if is_jump_pressed and is_on_floor:
		velocity.y = jump_velocity
		_is_jumping = true
		_is_falling = false
	elif is_on_floor:
		_is_jumping = false
		_is_falling = false
			
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	if direction:
		if _is_running:
			velocity.x = direction * move_speed * run_multiplier
		else:
			velocity.x = direction * move_speed
	else:
		velocity.x = move_toward(velocity.x, 0, move_speed)
		
	# Handle Ceiling, Walls and the gravity.
	if is_on_ceiling():
		velocity.y = gravity * delta
	elif is_on_wall():
		velocity.y = 0
		if is_jump_pressed:
			if sprite.flip_h:
				velocity.x = wall_jump_horizontal
			else:
				velocity.x = -wall_jump_horizontal
			velocity.y = jump_velocity
	elif not is_on_floor:
		velocity.y += gravity * delta
			
	# Clamp final velocities
	velocity.x = clamp(velocity.x, -max_velocity.x, max_velocity.x)
	velocity.y = clamp(velocity.y, -max_velocity.y, max_velocity.y)
		
	# Update animation directions
	var velocity_direction = velocity.normalized()	
	print(velocity_direction)
	animation_tree.set("parameters/Jump/blend_position", velocity_direction)	
	if velocity_direction.y == 1:
		_is_falling = true
		
	var input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)	
	if (input_direction != Vector2.ZERO):
		animation_tree.set("parameters/Run/blend_position", input_direction)
		animation_tree.set("parameters/Walk/blend_position", input_direction)
		animation_tree.set("parameters/Idle/blend_position", input_direction)
	else:
		_is_running = false
		_duration_pressed = 0
		
	move_and_slide()
	
	if _is_falling or _is_jumping:
		state_machine.travel("Jump")
	# Handle what state to use for animations
	elif (velocity.x != 0):
		if _is_running:
			state_machine.travel("Run")
		else:
			state_machine.travel("Walk")
	else:
		state_machine.travel("Idle")
	

