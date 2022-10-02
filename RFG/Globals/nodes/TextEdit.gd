extends TextEdit

signal text_updated(text_value)

func _ready():
	GlobalSignals.add_emitter('text_updated', self)
	GlobalSignals.emit_signal_when_ready('text_updated', ['text in _ready()'], self)
	text_changed.connect(_on_Text_changed)

func _on_Text_changed():
	emit_signal('text_updated', text)
	GlobalSignals.emit_signal_when_ready('text_updated', [text], self)
