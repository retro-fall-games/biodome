extends Area2D
class_name Hotspot
	
@export var names : Array
@export var global : bool = false
@export var within_collider : bool = false

var commands = {
	"look": "look",
	"examine": "look",
	"search": "look",
	"read": "look",
	"take": "take",
	"grab": "take",
	"get": "take",
	"use": "use",
	"open": "open",
	"close": "close",
	"talk": "talk",
	"speak": "talk",
	"chat": "talk"
}

@export var nouns : Array
@export var adjectives : Array
@export var verbs : Array

@export var not_close_enough_message : String
@export var on_look_message : String
@export var on_use_message : String
@export var on_talk_message : String
@export var on_take_message : String
@export var on_open_message : String
@export var on_close_message : String

signal on_not_close_enough(message)
signal on_look(message)
signal on_use(message)
signal on_talk(message)
signal on_take(message)
signal on_open(message)
signal on_close(message)

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
		emit_signal("on_not_close_enough", not_close_enough_message)
		pass
	match interaction:
		"look":
			emit_signal("on_look", on_look_message)
		"use":
			emit_signal("on_use", on_use_message)
		"talk":
			emit_signal("on_talk", on_talk_message)
		"take":
			emit_signal("on_take", on_take_message)
		"open":
			emit_signal("on_open", on_open_message)
		"close":
			emit_signal("on_close", on_close_message)
		
func get_class():
	return "Hotspot"

func is_class(value):
	if value == "Hotspot":
		return true
	else:
		return false
