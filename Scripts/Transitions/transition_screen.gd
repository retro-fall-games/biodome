extends CanvasLayer

signal fade_out_finished
signal fade_in_finished

@export var fade_in_on_start: bool = true
@export var wait_to_fade_in: float = 1
@export var wait_to_fade_out: float = 1

func _ready():
	if fade_in_on_start:
		fade_in()
		
func fade_out():
	await get_tree().create_timer(wait_to_fade_out).timeout
	$AnimationPlayer.play("fade_to_black")

func fade_in():
	await get_tree().create_timer(wait_to_fade_in).timeout
	$AnimationPlayer.play("fade_to_normal")

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "fade_to_black":
		emit_signal("fade_out_finished")
	if anim_name == "fade_to_normal":
		emit_signal("fade_in_finished")
