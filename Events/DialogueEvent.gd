class_name DialogueEvent
extends EventMap

# TODO Swap out event dialogs, 
# depending on game progression.

# TODO For dialogs _init_goals() is
# critical so enforce it as an overide.

export(String) var dialog_name = "unknown"

func _ready():
	# TODO self._init_goals()
	self._type = Type.Dialogue

func end_event():
	yield(get_tree(), "idle_frame")
	print("%s ending" % name)

func start_event():
	emit_signal("stats_updated", _goals)
	yield(get_tree(), "idle_frame")
	print("%s starting" % name)
	self.open_dialog()

func open_dialog():
	var box = DialogueSystem.show_dialogue(dialog_name)
	if box != null: box.connect_signals(self)
