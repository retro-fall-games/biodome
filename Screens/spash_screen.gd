extends Node2D

@export var scene : String

func _goto_scene():
	$TransitionScreen.fade_out()

func _input(event):
	if (event is InputEventKey):
		_goto_scene()

func _on_animation_player_animation_finished(anim_name):
	_goto_scene()

func _on_transition_screen_fade_out_finished():
	Global.goto_scene(scene)

func _on_transition_screen_fade_in_finished():
	await get_tree().create_timer(0.5).timeout
	$AnimationPlayer.play("DoSplash")
