class_name Character
extends CharacterBody2D

@export var gravity = 4
@export var max_velocity : Vector2 = Vector2(500, 500)

@onready var animation_player = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var states = $state_manager

signal health_depleted
signal health_changed(old_value, new_value)

var health = 10
var _default_gravity = 0

func _ready() -> void:
	# Initialize the state machine, passing a reference of the player to the states,
	# that way they can move and react accordingly
	states.init(self)
	_default_gravity = gravity

func _unhandled_input(event: InputEvent) -> void:
	states.input(event)

func _physics_process(delta: float) -> void:
	states.physics_process(delta)

func _process(delta: float) -> void:
	states.process(delta)
	
func is_going_down_slope() -> bool:
	var angle = get_floor_angle()
	# print(angle)
	return angle > 0 and velocity.y > 0
	
func is_going_up_slope() -> bool:
	var angle = get_floor_angle()
	# print(angle)
	return angle > 0 and velocity.y <= 0

func reset_velocity() -> void:
	velocity.x = 0
	velocity.y = 0
	
func reset_x_velocity() -> void:
	velocity.x = 0
	
func reset_y_velocity() -> void:
	velocity.y = 0

func apply_gravity() -> void:
	velocity.y += gravity
	
func reset_gravity():
	gravity = _default_gravity
	
func move() -> void:
	# Max Velocity Clamp
	velocity.x = clamp(velocity.x, -max_velocity.x, max_velocity.x)
	velocity.y = clamp(velocity.y, -max_velocity.y, max_velocity.y)
	# Set direction based on velocity x
	if(velocity.x > 0):
		scale.x = scale.y * 1
	elif(velocity.x < 0):
		scale.x = scale.y * -1
	move_and_slide()
	
func move_snap() -> void:
	# Max Velocity Clamp
	velocity.x = clamp(velocity.x, -max_velocity.x, max_velocity.x)
	velocity.y = clamp(velocity.y, -max_velocity.y, max_velocity.y)
	# Set direction based on velocity x
	if(velocity.x > 0):
		scale.x = scale.y * 1
	elif(velocity.x < 0):
		scale.x = scale.y * -1
	move_and_collide(Vector2(0, 0))
	
func set_force_x(x) -> void:
	velocity.x = x
	
func add_force_x(x) -> void:
	velocity.x += x
	
func set_force_y(y) -> void:
	velocity.y = y
	
func add_force_y(y) -> void:
	velocity.y += y

func _on_button_pressed():
	print("Hello")
	
func take_damage(amount):
	health -= amount
	if health <= 0:
		emit_signal("health_depleted")
		
func take_damage2(amount):
	var old_health = health
	health -= amount
	emit_signal("health_changed", old_health, health)
