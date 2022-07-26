class_name AdventureCharacter
extends CharacterBody2D

enum CharacterType { Player, NPC }
enum MovementDirection { Up, Down, Left, Right, UpLeft, UpRight, DownLeft, DownRight }
enum MovementState { Idle, Walking }

@export var character_type : CharacterType
@export var move_speed : Vector2 = Vector2(40, 20)
@export var animation_idle_x : String = "IdleX"
@export var animation_idle_up : String = "IdleUp"
@export var animation_idle_down : String = "IdleDown"
@export var animation_walk_x : String = "WalkX"
@export var animation_walk_up : String = "WalkUp"
@export var animation_walk_down : String = "WalkDown"

@onready var animation_player = $AnimationPlayer

var movement_direction = MovementDirection.Down
var movement_state = MovementState.Idle
var input : Vector2 = Vector2(40, 40)

func _ready():
	GlobalSignals.add_listener('spawn_player', self, '_on_Spawn_player')

func _physics_process(delta):
	if character_type == CharacterType.NPC:
		return
		
	# handle_input
	if Input.is_action_just_pressed("up"):
		change_movement_state(MovementDirection.Up, 0, -1)
	if Input.is_action_just_pressed("down"):
		change_movement_state(MovementDirection.Down, 0, 1)
	if Input.is_action_just_pressed("left"):
		change_movement_state(MovementDirection.Left, -1, 0)
	if Input.is_action_just_pressed("right"):
		change_movement_state(MovementDirection.Right, 1, 0)
	if Input.is_action_just_pressed("leftup"):
		change_movement_state(MovementDirection.UpLeft, -1, -1)
	if Input.is_action_just_pressed("rightup"):
		change_movement_state(MovementDirection.UpRight, 1, -1)
	if Input.is_action_just_pressed("leftdown"):
		change_movement_state(MovementDirection.DownLeft, -1, 1)
	if Input.is_action_just_pressed("rightdown"):
		change_movement_state(MovementDirection.DownRight, 1, 1)
		
	# move
	move_and_slide()
	
	# handle_collisions
	if get_slide_collision_count() > 0:
		movement_state = MovementState.Idle
		input.x = 0
		input.y = 0
		update_animations()
	
	# handle flip facing towards
	if velocity.x > 0:
		scale.x = scale.y * 1
	elif velocity.x < 0:
		scale.x = scale.y * -1
		
func change_movement_state(move_direction : MovementDirection, x : float, y : float):
	if (move_direction != movement_direction):
		movement_state = MovementState.Walking
		input.x = x
		input.y = y
		movement_direction = move_direction
	elif (movement_state == MovementState.Walking):
		movement_state = MovementState.Idle
		input.x = 0
		input.y = 0
	else:
		movement_state = MovementState.Walking
		input.x = x
		input.y = y
		movement_direction = move_direction
	velocity.x = input.x * move_speed.x
	velocity.y = input.y * move_speed.y
	update_animations()
	
func update_animations():
	if (velocity.x > 0):
		animation_player.play(animation_walk_x)
	elif (velocity.x < 0):
		animation_player.play(animation_walk_x)
	elif (velocity.y < 0):
		animation_player.play(animation_walk_up)
	elif (velocity.y > 0):
		animation_player.play(animation_walk_down)
	else:
		update_movement_direction()

func update_movement_direction():
	match movement_direction:
		MovementDirection.Up:
			animation_player.play(animation_idle_up)
		MovementDirection.Down:
			animation_player.play(animation_idle_down)
		MovementDirection.Left:
			animation_player.play(animation_idle_x)
		MovementDirection.Right:
			animation_player.play(animation_idle_x)
		_:
			animation_player.play(animation_idle_x)

func _on_Spawn_player(new_position, move_direction):
	if character_type == CharacterType.NPC:
		return
	position = new_position
	if move_direction != null:
		movement_direction = move_direction
		update_movement_direction()
		if move_direction == MovementDirection.Left:
			scale.x = scale.y * -1	

func save():
	var save_dict = {
		"filename" : get_path(),
		"parent" : get_parent().get_path(),
		"pos_x" : position.x,
		"pos_y" : position.y
	}
	return save_dict
