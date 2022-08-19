extends CharacterBody2D

@export var move_speed : Vector2 = Vector2(40, 40)

@onready var animation_player = $AnimationPlayer

enum MovementDirection { Up, Down, Left, Right, UpLeft, UpRight, DownLeft, DownRight }
enum MovementState { Idle, Walking }

var movement_direction = MovementDirection.Down
var movement_state = MovementState.Idle

var input : Vector2 = Vector2(40, 40)

func _ready():
	pass
	
func _input(event):
	if event is InputEventKey and event.is_pressed():
		if event.keycode >= KEY_A and event.keycode <= KEY_Z:
			print ("Letter")
		elif event.keycode >= KEY_0 and event.keycode <= KEY_9:
			print ("Number")
		elif event.keycode >= KEY_KP_0 and event.keycode <= KEY_KP_9:
			print ("Keypad Number")
		elif event.keycode == KEY_ENTER:
			print ("Enter")

func _physics_process(delta):
				
	move_and_slide()
	
	if velocity.x > 0:
		scale.x = scale.y * 1
	elif velocity.x < 0:
		scale.x = scale.y * -1
		
func detect_movement_state():
	if (velocity.x > 0):
		# _character.MovementState.ChangeState(typeof(WalkRightState));
		print("right")
	elif (velocity.x < 0):
		# _character.MovementState.ChangeState(typeof(WalkLeftState));
		print("left")
	elif (velocity.y > 0):
		# _character.MovementState.ChangeState(typeof(WalkUpState));
		print("up")
	elif (velocity.y < 0):
		# _character.MovementState.ChangeState(typeof(WalkDownState));
		print("down")
	else:
		match movement_direction:
			MovementDirection.Up:
				# _character.MovementState.ChangeState(typeof(WalkUpIdleState));
				print("up")
			MovementDirection.Down:
				#_character.MovementState.ChangeState(typeof(WalkDownIdleState));
				print("down")
			MovementDirection.Left:
				#_character.MovementState.ChangeState(typeof(WalkLeftIdleState));
				print("left")
			MovementDirection.Right:
				#_character.MovementState.ChangeState(typeof(WalkRightIdleState));
				print("right")
			_:
				#_character.MovementState.ChangeState(typeof(IdleState));
				print("idle")


func change_movement_state(move_direction : MovementDirection, x : float, y : float):
	if (move_direction != movement_direction):
		movement_state = MovementState.Walking;
		input.x = x;
		input.y = y;
		movement_direction = move_direction;
	elif (movement_state == MovementState.Walking):
		movement_state = MovementState.Idle;
		input.x = 0;
		input.y = 0;
	else:
		movement_state = MovementState.Walking;
		input.x = x;
		input.y = y;
		movement_direction = move_direction;
	velocity.x = input.x * move_speed.x
	velocity.y = input.y * move_speed.y
	detect_movement_state()
	
func OnWalkUp():
	change_movement_state(MovementDirection.Up, 0, 1)

func OnWalkDown():
	change_movement_state(MovementDirection.Down, 0, -1)

func OnWalkLeft():
	change_movement_state(MovementDirection.Left, -1, 0)

func OnWalkRight():
	change_movement_state(MovementDirection.Right, 1, 0)

func OnWalkUpLeft():
	change_movement_state(MovementDirection.UpLeft, -1, 1)

func OnWalkUpRight():
	change_movement_state(MovementDirection.UpRight, 1, 1)

func OnWalkDownLeft():
	change_movement_state(MovementDirection.DownLeft, -1, -1)

func OnWalkDownRight():
	change_movement_state(MovementDirection.DownRight, 1, -1)
