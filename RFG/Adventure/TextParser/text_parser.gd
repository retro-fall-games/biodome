extends Node

@onready var text_prompt = $TextPrompt
@onready var text = $TextPrompt/MarginContainer/MarginContainer/HBoxContainer/TextEdit

var verb : String
var subject : String
var subject_parts : Array
var interaction : String
var hotspots : Array
var dialog : Dialog

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

func _ready():
	text_prompt.visible = false
	var owner = get_owner()
	if !owner:
		owner = self
	find_hotspots(owner, hotspots)
	dialog = owner.find_child("Dialog")

func _input(event):
	if event is InputEventKey and event.is_pressed():
		if event.keycode == KEY_ENTER:
			if text_prompt.visible:
				process_command(text.text)
				text_prompt.visible = false
				get_tree().paused = false
			elif !dialog.is_showing():
				text_prompt.visible = true
				text.grab_focus()
				get_tree().paused = true
			await get_tree().create_timer(.01).timeout 
			text.text = ""

func find_hotspots(node: Node, result : Array) -> void:
	if node is Hotspot:
		result.push_back(node)
	for child in node.get_children():
		find_hotspots(child, result)

func process_command(command: String):
	command = command.strip_edges(true, true)
	# print("You have entered the command: ", command)
	
	if command == "":
		dialog.set_text("I don't understand what you mean")

	var sentence = command.split(" ", false, 2)
	
	if sentence.size() == 0:
		dialog.set_text("I don't understand what you mean")
		return
	
	parse_text(sentence)
		
	if interaction:
		var hotspot = find_hotspot()
		if hotspot:
			hotspot.run_interaction(interaction);
			return
#
	dialog.set_text("You can't do that")
	
func parse_text(sentence):
	verb = sentence[0];
	if sentence.size() == 1:
		interaction = "look";
	elif sentence.size() > 1:
		subject = sentence[1] # StopwordTool.RemoveStopwords(sentence[1]);
		subject_parts = subject.split(" ", true, 2);
		interaction = commands[verb];
	
func find_hotspot() -> Hotspot:
	for hotspot in hotspots:
		if hotspot.is_visible_in_tree() and hotspot.has_verb(verb):
			var has_subject = subject != "";
			if verb == "look" and !has_subject and hotspot.nouns.size() == 0 and hotspot.adjectives.size() == 0:
				return hotspot
			elif has_subject:
				var has_one = subject_parts.size() == 1;
				var has_more_than_one = subject_parts.size() > 1;
				var has_verb = hotspot.has_verb(verb);
				var has_noun = hotspot.has_noun(subject_parts[0]);
				if !has_noun and has_more_than_one:
					has_noun = hotspot.has_noun(subject_parts[1]);
				var has_adjective = hotspot.has_adjective(subject_parts[0])
				if !has_adjective and has_more_than_one:
					has_adjective = hotspot.has_adjective(subject_parts[1])
					
				if has_verb and has_noun and has_adjective and has_more_than_one:
					return hotspot
				if has_verb and (has_noun or has_adjective) and has_one:
					return hotspot
	return null;
