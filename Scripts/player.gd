class_name Player
extends CharacterBody2D

@export var gravity = 4

@onready var animation_player = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var states = $state_manager

func _ready() -> void:
	# Initialize the state machine, passing a reference of the player to the states,
	# that way they can move and react accordingly
	states.init(self)

func _unhandled_input(event: InputEvent) -> void:
	states.input(event)

func _physics_process(delta: float) -> void:
	states.physics_process(delta)

func _process(delta: float) -> void:
	states.process(delta)
	
func flip() -> void:
	if(velocity.x > 0):
		scale.x = scale.y * 1
	elif(velocity.x < 0):
		scale.x = scale.y * -1

	
func is_going_down_slope() -> bool:
	var angle = get_floor_angle()
	print(angle)
	return angle > 0 and velocity.y > 0
	
func is_going_up_slope() -> bool:
	var angle = get_floor_angle()
	print(angle)
	return angle > 0 and velocity.y <= 0
