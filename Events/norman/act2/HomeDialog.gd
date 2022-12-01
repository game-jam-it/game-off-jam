extends DialogueEvent

enum State {
	Base,
}

enum Action {
	None,
}

onready var base = preload("res://Dialogue/norman/act2/home-base.gd")

# State defines the dialogue to open
# when the player enters the map event.
var state = State.Base

# Action defines extra steps to
# run after the dialog is closed.
var action = Action.None

func _ready():
	self._init_goals()
	self._type = Type.Dialogue
	TheTown.connect("game_stats_updated", self, "_on_game_stats_updated")

func _init_goals():
	self._goals =  EventMap.new_goals()
	self._goals.lore.total = 1

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
	var box = DialogueSystem.show_dialogue(base.dialogue)
	if box != null: box.connect_signals(self)
	self.action = Action.None
	pass

func _on_game_stats_updated(stats):
	# FixMe This does not complete the map ...
	# also the other act2 maps don't compelte ether
	print("[%s] >>> _on_bones_died" % [name])
	if self._goals.lore.done == 0:
		if stats.banish.boss.done == stats.banish.boss.total:
			print("[%s] >>> _on_bones_died +++" % [name])
			self._goals.lore.done = 1
			emit_signal("stats_updated", _goals)
			self.mark_complete()
