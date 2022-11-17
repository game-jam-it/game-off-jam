extends EntityInput

var current_goal = 0

signal _action_selected(action)
signal _target_selected(target)

func end():
	current_goal = 0

func start():
	current_goal = 3

func choose_action():
	current_goal = 1
	print("%s choose action" % entity.name)
	return yield(self, "_action_selected")

func choose_target():
	current_goal = 2
	print("%s choose target" % entity.name)
	return yield(self, "_target_selected")


"""
	Handle Player Input
"""

func _input(event):
	match current_goal:
		1: _action_input(event)
		2: _target_input(event)
		3: _idling_input(event)

func _process(delta):
	match current_goal:
		1: _action_process(delta)
		2: _target_process(delta)
		3: _idling_process(delta)


"""
	Handle Idle Input
"""
	
func _idling_input(_event):
	pass

func _idling_process(_delta):
	pass


"""
	Handle Action Input
"""

func _action_input(event):
	if event.is_action_pressed("ui_cancel"):
		current_goal = 0
		emit_signal("_action_selected", null)

func _action_process(_delta):
	pass


"""
	Handle Target Input
"""

func _target_input(event):
	if event.is_action_pressed("ui_cancel"):
		current_goal = 0
		emit_signal("_target_selected", null)

func _target_process(_delta):
	pass
