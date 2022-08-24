extends Area2D
class_name Hotspot
	
@export var names : Array
@export var global : bool = false
@export var within_collider : bool = false
@export var nouns : Array
@export var adjectives : Array
@export var verbs : Array
@export var not_close_enough_message : Array
@export var on_look_message : Array
@export var on_use_message : Array
@export var on_talk_message : Array
@export var on_take_message : Array
@export var on_open_message : Array
@export var on_close_message : Array

signal on_not_close_enough(message)
signal on_look(message)
signal on_use(message)
signal on_talk(message)
signal on_take(message)
signal on_open(message)
signal on_close(message)
signal on_dialog_message(message)

func _on_hotspot_body_entered(body):
	if String(body.name) in names:
		within_collider = true

func _on_hotspot_body_exited(body):
	if String(body.name) in names:
		within_collider = false
		
func has_noun(noun):
	return nouns.has(noun)

func has_verb(verb):
	return verbs.has(verb)

func has_adjective(adjective):
	return adjectives.has(adjective)

func run_interaction(interaction):
	if !global and !within_collider:
		for message in not_close_enough_message:
			emit_signal("on_not_close_enough", message)
			emit_signal("on_dialog_message", message)
		return
				
	match interaction:
		"look":
			for message in on_look_message:
				emit_signal("on_look", message)
				emit_signal("on_dialog_message", message)
		"use":
			for message in on_use_message:
				emit_signal("on_use", message)
				emit_signal("on_dialog_message", message)
		"talk":
			for message in on_talk_message:
				emit_signal("on_talk", message)
				emit_signal("on_dialog_message", message)
		"take":
			for message in on_take_message:
				emit_signal("on_take", message)
				emit_signal("on_dialog_message", message)
		"open":
			for message in on_open_message:
				emit_signal("on_open", message)
				emit_signal("on_dialog_message", message)
		"close":
			for message in on_close_message:
				emit_signal("on_close", message)
				emit_signal("on_dialog_message", message)
		
func get_class():
	return "Hotspot"

func is_class(value):
	if value == "Hotspot":
		return true
	else:
		return false
