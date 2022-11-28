extends DialogueEvent

enum State {
	Base,
}

enum Action {
	None,
}

# State defines the dialogue to open
# when the player enters the map event.
var state = State.Base

# Action defines extra steps to
# run after the dialog is closed.
var action = Action.None

# Repeat counter causes stress for
# the player if he repeats to often.
var _repeat_count = 0;
var _remember_count = 0;


func open_dialog():
	match state:
		State.Base: self._home_base()

func on_dialogue_closed():
	match self.action:
		Action.None: TheTown.stop_active_event()

"""
	Dialog Options
"""

func _home_base():
	var box = DialogueSystem.show_dialogue("norman/act2/home-base")
	if box != null: box.connect_signals(self)
	self.action = Action.None

