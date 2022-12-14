class_name DialogueMap
extends EventMap

# TODO Swap out event dialogs, 
# depending on game progression.

# TODO For dialogs _init_goals() is
# critical so enforce it as an overide.

export(String) var dialog_name = "unknown"

onready var _moon_light = $MoonLight

func _ready():
	self._init_goals()
	self._type = Type.Dialogue
	_moon_light.visible = false

func end_event():
	yield(get_tree(), "idle_frame")
	_moon_light.visible = false
	print("%s ending" % name)

func start_event():
	yield(get_tree(), "idle_frame")
	print("%s starting" % name)
	_moon_light.visible = true
	self.open_dialog()

func open_dialog():
	var box = DialogueSystem.show_dialogue(dialog_name)
	if box != null: box.connect_signals(self)
