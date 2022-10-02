# TestLabel
extends Label

func _ready():
	GlobalSignals.add_listener('text_updated', self, '_on_Text_updated')

func _on_Text_updated(text_value: String):
	text = text_value
