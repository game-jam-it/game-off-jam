extends EntityInput

var current_goal = 0

signal _action_selected(action)
signal _targets_selected(target)

func choose_action():
	return yield(self, "_action_selected")

func choose_target():
	return yield(self, "_targets_selected")


"""
	Handle Player Input
"""

func _input(event):
	match current_goal:
		1: _action_input(event)
		2: _target_input(event)

func _process(delta):
	match current_goal:
		1: _action_process(event)
		2: _target_process(event)


"""
	Handle Action Selection
"""

func _action_input(event):
	if event.is_action_pressed("ui_cancel"):
		current_goal = 0
		emit_signal("_action_selected", null)

func _action_process(_delta):
	pass


"""
	Handle Target Selection
"""

func _target_input(_event):
	if event.is_action_pressed("ui_cancel"):
		current_goal = 0
		emit_signal("_targets_selected", null)

func _target_process(_delta):
	pass