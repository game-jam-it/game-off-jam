class_name DialogueEvent
extends EventMap

# TODO Swap out event dialogs, 
# depending on game progression.

export(String) var dialog_name = "unknown"

func _ready():
	# TODO self._init_goals()
	_type = Type.Dialogue

func end_event():
	print("%s ending" % name)
	yield(get_tree(), "idle_frame")

func start_event():
	print("%s starting" % name)
	yield(get_tree(), "idle_frame")
	var box = DialogueSystem.show_dialogue(dialog_name)
	box.connect_signals(self)
