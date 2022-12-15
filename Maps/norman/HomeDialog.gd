extends DialogueMap

# Note: Hardcoded value in event name here
const REWARD_MAP = "Cemetary"
# Note: Cliche: do not bump a rock three times
const MAX_REMINDERS = 3

enum State {
	Base,
	Start,
	Closer,
}

enum Action {
	None,
	Sleep,
	MoveOut,
	CloseAct,
	CloseGame,
	FocusReward
}

onready var base = preload("res://Dialogue/norman/act1/home-base.gd")
onready var intro = preload("res://Dialogue/norman/act1/home-intro.gd")
onready var restless = preload("res://Dialogue/norman/act1/home-restless.gd")
onready var game_over = preload("res://Dialogue/norman/act1/home-game-over.gd")
onready var repeat_glow = preload("res://Dialogue/norman/act1/home-repeat-glow.gd")
onready var remember_glow = preload("res://Dialogue/norman/act1/home-remember-glow.gd")

# State defines the dialogue to open
# when the player enters the map event.
var state = State.Start

# Action defines extra steps to
# run after the dialog is closed.
var action = Action.None

# Repeat counter causes stress for
# the player if he repeats to often.
var _repeat_count = 0;
var _remember_count = 0;

func _ready():
	self._init_goals()
	self._type = Type.Dialogue

func _init_goals():
	self._goals =  EventMap.new_goals()
	self._goals.lore.total = 2

func open_dialog():
	match state:
		State.Base: self._base_check()
		State.Start: self._home_start()
		State.Closer: self._home_closer()

func on_dialogue_closed():
	match self.action:
		Action.None: TheTown.stop_active_event()
		Action.Sleep: self._run_sleep()
		Action.MoveOut: self._run_move_out()
		Action.CloseAct: self._run_close_act()
		Action.CloseGame: self._run_close_game()
		Action.FocusReward: self._focus_on_reward_map()

func on_dialogue_event(value: String):
	print("%s Dialogue_event: %s" % [name, value])
	match value:
		# act1/home-base events
		"Sleep": self.action = Action.Sleep
		"MoveOut": self.action = Action.MoveOut

func _base_check():
	var event = TheTown.get_events().get_node(REWARD_MAP)
	if event != null && !event.is_locked(): 
		if event.is_complete():
			self._home_closer()
		else:
			_remember_count +=1
			if _remember_count < MAX_REMINDERS:
				self._home_remember_glow()
			else:
				self._home_game_over()
	else:
		_repeat_count +=1
		if _repeat_count < MAX_REMINDERS:
			self._home_remember_glow()
		else:
			self._home_game_over()


"""
	Dialog Options
"""

func _home_base():
	var box = DialogueSystem.show_dialogue(base.dialogue)
	if box != null: box.connect_signals(self)
	self.action = Action.None

func _home_start():
	var box = DialogueSystem.show_dialogue(intro.dialogue)
	if box != null: box.connect_signals(self)
	self.action = Action.None

func _home_closer():
	# TODO Fade to black and start kill event with dialog triggers
	var box = DialogueSystem.show_dialogue(restless.dialogue)
	if box != null: box.connect_signals(self)
	# TODO Setup Act2 maps and data and enable
	#print("[%s] TODO Enable Atc2" % name)
	self.action = Action.CloseAct
	#self.action = Action.CloseGame

func _home_game_over():
	# TODO: game over dialog
	var box = DialogueSystem.show_dialogue(game_over.dialogue)
	if box != null: box.connect_signals(self)
	self.action = Action.CloseGame

func _home_repeat_glow():
	# TODO: Slasher nightmare; increase stress
	# TODO: Repeat glow at cemetery dialog
	var box = DialogueSystem.show_dialogue(repeat_glow.dialogue)
	if box != null: box.connect_signals(self)
	self.action = Action.FocusReward

func _home_remember_glow():
	# TODO: Slasher nightmare; increase stress
	# TODO: Remember glow at cemetery dialog
	var box = DialogueSystem.show_dialogue(remember_glow.dialogue)
	if box != null: box.connect_signals(self)
	self.action = Action.FocusReward


"""
	Runners for post dialog actions
"""

func _run_sleep():
	yield(get_tree(), "idle_frame")
	self.action = Action.None
	self.state = State.Closer
	self._home_closer()

func _run_move_out():
	self._goals.lore.done += 1
	emit_signal("stats_updated", _goals)
	self.state = State.Base
	self.action = Action.None
	self._focus_on_reward_map()

func _run_close_act():
	self._complete = true
	self._goals.lore.done += 1
	emit_signal("stats_updated", _goals)
	TheTown.stop_active_event()
	TheTown.restart(TheTown.Act.Teens)

func _run_close_game():
	TheTown.game_over()

func _focus_on_reward_map():
	TheTown.stop_active_event()
	var event = TheTown.get_events().get_node(REWARD_MAP)
	if event != null: 
		event.unlock()
		var coords = event.coords()
		TheTown.get_nodes().set_focus(coords)
		TheTown.get_nodes().select_focus()
