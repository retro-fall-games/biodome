extends Node

@onready var text_prompt = $TextPrompt
@onready var text = $TextPrompt/MarginContainer/MarginContainer/HBoxContainer/TextEdit

var verb : String
var subject : String
var subject_parts : Array
var interaction : String
var hotspots : Array

func _ready():
	text_prompt.visible = false
	var owner = get_owner()
	if !owner:
		owner = self
	print(owner)
	find_hotspots(owner, hotspots)
	print(hotspots)

func _input(event):
	if event is InputEventKey and event.is_pressed():
		if event.keycode == KEY_ENTER:
			if text_prompt.visible:
				process_command(text.text)
				text_prompt.visible = false
				get_tree().paused = false
			else:
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
	print("You have entered the command: ", command)

	if command == "":
		pass
		#throw new DontUnderstandException();

	var sentence = command.split(" ", false, 2)
	var parsed_text = parse_text(sentence)
	
	if !parsed_text:
		pass
		#throw new CantDoException();

#		Hotspot hotspot = FindHotspot(parsedText);
#
#		if (hotspot != null)
#		  hotspot.RunInteraction(parsedText.interaction);
#		  return;
#		throw new CantDoException();
#	  catch (DontUnderstandException)
#		DontUnderstand();
#	  catch (CantDoException)
#
#		CantDo();
	
func parse_text(sentence):
	pass
#    ParsedText parsedText = new ParsedText();
#    parsedText.verb = sentence[0];
#    if (sentence.Length == 1)
#    {
#    parsedText.interaction = "look";
#    return parsedText;
#    }
#    else if (sentence.Length > 1)
#    {
#    parsedText.subject = StopwordTool.RemoveStopwords(sentence[1]);
#    parsedText.subjectParts = parsedText.subject.Split(new[] { ' ' }, 2);
#    string interaction;
#    if (InteractionDictionary.verbs.TryGetValue(parsedText.verb, out interaction))
#    {
#        parsedText.interaction = interaction;
#        return parsedText;
#    }
#    }
#    return null;
	
#private Hotspot FindHotspot(ParsedText parsedText)
#    {
#      List<Hotspot> hotspots = FindVisibleHotspots();
#      // Go through all the visible hotspots on the screen and match them to the text
#      foreach (Hotspot hotspot in hotspots)
#      {
#        int verbIndex = hotspot.Verbs.FindIndex(i => i == parsedText.verb);
#        if (verbIndex > -1)
#        {
#          var hasSubject = !string.IsNullOrEmpty(parsedText.subject);
#          if (
#            parsedText.verb.Equals("look") &&
#            !hasSubject &&
#            hotspot.Nouns.Count == 0 &&
#            hotspot.Adjectives.Count == 0)
#          {
#            return hotspot;
#          }
#          else if (hasSubject)
#          {
#            bool hasOne = parsedText.subjectParts.Length == 1;
#            bool hasMoreThanOne = parsedText.subjectParts.Length > 1;
#            bool hasVerb = hotspot.HasVerb(parsedText.verb);
#            bool hasNoun = hotspot.HasNoun(parsedText.subjectParts[0]);
#            if (!hasNoun && hasMoreThanOne)
#            {
#              hasNoun = hotspot.HasNoun(parsedText.subjectParts[1]);
#            }
#            bool hasAdjective = hotspot.HasAdjective(parsedText.subjectParts[0]);
#            if (!hasAdjective && hasMoreThanOne)
#            {
#              hasAdjective = hotspot.HasAdjective(parsedText.subjectParts[1]);
#            }
#            if (hasVerb && hasNoun && hasAdjective && hasMoreThanOne)
#            {
#              return hotspot;
#            }
#            if (hasVerb && (hasNoun || hasAdjective) && hasOne)
#            {
#              return hotspot;
#            }
#          }
#        }
#      }
#      return null;
#    }
